import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/audio_provider.dart'; // ✅ добавили AudioProvider
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final audioProvider = Provider.of<AudioProvider>(context); // ✅

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Темная тема
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.darkTheme),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),

            // Язык
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

            // Музыка
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.backgroundMusic),
              value: audioProvider.isPlaying,
              onChanged: (value) => audioProvider.toggleMusic(value),
            ),
          ],
        ),
      ),
    );
  }
}
