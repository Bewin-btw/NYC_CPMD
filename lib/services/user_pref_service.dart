import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserPrefService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Сохраняет настройки пользователя в Firestore
  Future<void> savePreferences({
  String? name,
  String? age,
  String? email,
  String? languageCode,
  bool? isDarkMode,
}) async {
  final user = _auth.currentUser;

  // 🔸 Сохраняем локально
  final prefs = await SharedPreferences.getInstance();
  if (languageCode != null) await prefs.setString('language', languageCode);
  if (isDarkMode != null) await prefs.setBool('isDarkMode', isDarkMode);

  // 🔸 Пытаемся сохранить в Firestore
  if (user != null && !user.isAnonymous) {
    final Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (age != null) data['age'] = age;
    if (email != null) data['email'] = email;
    if (languageCode != null) data['language'] = languageCode;
    if (isDarkMode != null) data['isDarkMode'] = isDarkMode;

    try {
      await _firestore.collection('users').doc(user.uid).set(
        data,
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Ошибка при сохранении в Firebase: $e');
    }
  }
}


  /// Загружает настройки пользователя из Firestore
  Future<Map<String, dynamic>> loadPreferences() async {
  final prefs = await SharedPreferences.getInstance();

  final Map<String, dynamic> result = {
    'language': prefs.getString('language'),
    'isDarkMode': prefs.getBool('isDarkMode'),
  };

  final user = _auth.currentUser;
  if (user != null && !user.isAnonymous) {
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        result.addAll(doc.data() ?? {});
      }
    } catch (e) {
      print('Ошибка при загрузке из Firebase: $e');
    }
  }

  return result;
}

}
