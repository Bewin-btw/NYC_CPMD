import 'package:flutter/material.dart';
import '../services/user_pref_service.dart';
import 'theme_provider.dart'; // 👈 чтобы использовать ThemeProviderExtension
import 'theme_provider_extension.dart'; // 👈 чтобы использовать ThemeProviderExtension

class LocaleProvider with ChangeNotifier {
  Locale? _locale;

  Locale get locale => _locale ?? const Locale('en');

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;

    final isDark = ThemeProviderExtension.getCurrentThemeIsDark();

    await UserPrefService().savePreferences(
      languageCode: newLocale.languageCode,
      isDarkMode: isDark,
    );

    notifyListeners();
  }

  Future<void> loadUserLanguageFromFirebase() async {
    final prefs = await UserPrefService().loadPreferences();
    if (prefs == null) return;

    final lang = prefs['language'] ?? 'en';
    _locale = Locale(lang);
    notifyListeners();
  }

Future<void> loadDefaultLocaleForGuest() async {
  _locale = const Locale('en'); // всегда английский
  notifyListeners();
}
  Future<void> loadLocale() async {
    // просто делегируем загрузку из Firestore
    await loadUserLanguageFromFirebase();
  }
}
