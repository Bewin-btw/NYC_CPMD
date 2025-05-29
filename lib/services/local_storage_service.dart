import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyName = 'name';
  static const String _keyAge = 'age';
  static const String _keyEmail = 'email';
  static const String _keyTheme = 'theme';
  static const String _keyLanguage = 'language';

  Future<void> saveUserData({
    required String name,
    required String age,
    required String email,
    String? theme, // light/dark
    String? language, // en/ru/kk
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyAge, age);
    await prefs.setString(_keyEmail, email);
    if (theme != null) await prefs.setString(_keyTheme, theme);
    if (language != null) await prefs.setString(_keyLanguage, language);
  }

  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyName),
      'age': prefs.getString(_keyAge),
      'email': prefs.getString(_keyEmail),
      'theme': prefs.getString(_keyTheme),
      'language': prefs.getString(_keyLanguage),
    };
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyAge);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyTheme);
    await prefs.remove(_keyLanguage);
  }
}
