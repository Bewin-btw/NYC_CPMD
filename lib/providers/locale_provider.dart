import 'package:flutter/material.dart';
import '../services/user_pref_service.dart';
import 'theme_provider.dart'; // 👈 чтобы использовать ThemeProviderExtension
import 'theme_provider_extension.dart'; // 👈 чтобы использовать ThemeProviderExtension
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en')); // ✅ добавлено

  Locale get locale => _locale ?? const Locale('en');

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    localeNotifier.value = newLocale; // ✅ обновляем слушатель

    final isDark = ThemeProviderExtension.getCurrentThemeIsDark();

    // 🔁 Сохраняем локально
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);

    // 🔁 Пробуем сохранить в Firebase
    await UserPrefService().savePreferences(
      languageCode: newLocale.languageCode,
      isDarkMode: isDark,
    );

    notifyListeners();
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('languageCode') ?? 'en';
    _locale = Locale(code);
    localeNotifier.value = _locale!; // ✅ обязательно обновить
    notifyListeners();
  }

  Future<void> loadUserLanguageFromFirebase() async {
    final prefs = await UserPrefService().loadPreferences();
    if (prefs == null) return;

    final lang = prefs['language'] ?? 'en';
    _locale = Locale(lang);
    localeNotifier.value = _locale!;
    notifyListeners();
  }

  Future<void> loadDefaultLocaleForGuest() async {
    _locale = const Locale('en');
    localeNotifier.value = _locale!;
    notifyListeners();
  }
}
