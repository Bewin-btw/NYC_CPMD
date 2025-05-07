import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPrefService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Сохраняет настройки темы и языка в Firestore
  Future<void> savePreferences({
    required String languageCode,
    required bool isDarkMode,
  }) async {
    final user = _auth.currentUser;

    if (user == null || user.isAnonymous) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'language': languageCode,
        'isDarkMode': isDarkMode,
      }, SetOptions(merge: true));
    } catch (e) {
      // Можно добавить лог или обработку ошибок
      print('Ошибка при сохранении настроек: $e');
    }
  }

  /// Загружает настройки пользователя из Firestore
  Future<Map<String, dynamic>?> loadPreferences() async {
    final user = _auth.currentUser;

    if (user == null || user.isAnonymous) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Ошибка при загрузке настроек: $e');
      return null;
    }
  }
}
