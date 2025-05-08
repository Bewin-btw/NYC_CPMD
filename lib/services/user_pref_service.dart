import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPrefService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> savePreferences({
    String? name,
    String? age,
    String? email,
    String? languageCode,
    bool? isDarkMode,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.isAnonymous) return;

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
      print('Ошибка при сохранении настроек: $e');
    }
  }
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
