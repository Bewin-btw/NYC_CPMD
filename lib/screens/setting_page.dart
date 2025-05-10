import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/audio_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'auth_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);

    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.darkTheme),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.language),
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
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.backgroundMusic),
              value: audioProvider.isPlaying,
              onChanged: (value) => audioProvider.toggleMusic(value),
            ),
            const Divider(),

            if (isGuest)
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Login / Register'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthPage()),
                  );
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(AppLocalizations.of(context)!.logout),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
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
