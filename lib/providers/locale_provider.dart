import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_pref_service.dart';
import '../providers/theme_provider.dart';
import '../main.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;

  Locale get locale => _locale ?? const Locale('en');

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;

    // Сохраняем в SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);

    // Получаем текущую тему из ThemeProvider
    final isDark = ThemeProviderExtension.getCurrentThemeIsDark();

    // Сохраняем в Firestore
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

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');
    _locale = languageCode != null ? Locale(languageCode) : const Locale('en');
    notifyListeners();
  }
}
