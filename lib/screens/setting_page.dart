import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/audio_provider.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';
import 'auth_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: isGuest
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 64),
                  const SizedBox(height: 16),
                  Text("Please log in to access this feature.",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthPage()),
                      );
                    },
                    child: const Text("Go to Login"),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // 🌙 Темная тема
                  SwitchListTile(
                    title: Text(t.darkTheme),
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) => themeProvider.toggleTheme(value),
                  ),

                  // 🌐 Язык
                  ListTile(
                    title: Text(t.language),
                    trailing: DropdownButton<Locale>(
                      value: localeProvider.locale,
                      items: const [
                        Locale('en'),
                        Locale('ru'),
                        Locale('kk'),
                      ].map((locale) {
                        return DropdownMenuItem(
                          value: locale,
                          child: Text(locale.languageCode.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (locale) => localeProvider.setLocale(locale!),
                    ),
                  ),

                  // 🎵 Музыка
                  SwitchListTile(
                    title: Text(t.backgroundMusic),
                    value: audioProvider.isPlaying,
                    onChanged: (value) => audioProvider.toggleMusic(value),
                  ),

                  const Divider(),

                  // 🔄 Синхронизация
                  ListTile(
                    leading: const Icon(Icons.sync),
                    title: Text(t.syncNow), 
                    onTap: () async {
  final result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.syncFailedOffline)),
      );
    }
    return;
  }

  final local = LocalStorageService();

  final prefs = await SharedPreferences.getInstance();
  final theme = themeProvider.themeMode == ThemeMode.dark ? 'dark' : 'light';
  final language = localeProvider.locale.languageCode;
  await prefs.setString('theme', theme);
  await prefs.setString('language', language);

  final data = await local.getUserData();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid != null && data.isNotEmpty) {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(data);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Data synced successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Sync failed: $e')),
        );
      }
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ No local data to sync')),
      );
    }
  }
},
),
                  const Divider(),

                  // 🚪 Выход
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(t.logout),
                    onTap: () async {
                      await authService.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthPage()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
