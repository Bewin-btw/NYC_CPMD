import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_pref_service.dart';
import '../main.dart'; // для navigatorKey

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode, String languageCode) async {
    _themeMode = mode;

    await UserPrefService().savePreferences(
      languageCode: languageCode,
      isDarkMode: mode == ThemeMode.dark,
    );

    notifyListeners();
  }
Future<void> loadThemeFromPrefs() async {
  _themeMode = ThemeMode.light; // Гостевой пользователь — всегда светлая тема
  notifyListeners();
}
  Future<void> loadUserThemeFromFirebase() async {
    final prefs = await UserPrefService().loadPreferences();
    if (prefs == null) return;

    final isDark = prefs['isDarkMode'] ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}

// 👇 Отдельный вспомогательный класс
class ThemeProviderExtension {
  static bool getCurrentThemeIsDark() {
    try {
      final theme = Provider.of<ThemeProvider>(
        navigatorKey.currentContext!,
        listen: false,
      ).themeMode;

      return theme == ThemeMode.dark;
    } catch (_) {
      return false;
    }
  }
}
