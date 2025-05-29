import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'local_storage_service.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalStorageService _localStorage = LocalStorageService();

  User? get currentUser => _auth.currentUser;

  // Регистрация
  Future<String?> registerWithEmail(String email, String password, {
    required String name,
    required String age,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = userCredential.user!.uid;

      final userData = {
        'name': name,
        'age': age,
        'email': email.trim(),
      };

      await _firestore.collection('users').doc(uid).set(userData);
      await _localStorage.saveUserData(
        name: name,
        age: age,
        email: email.trim(),
      );

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Вход
  Future<String?> loginWithEmail(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null && user.isAnonymous) {
        await _auth.signOut();
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final doc = await _firestore.collection('users').doc(credential.user!.uid).get();
      if (doc.exists) {
        final data = doc.data();
        await _localStorage.saveUserData(
          name: data?['name'] ?? '',
          age: data?['age'] ?? '',
          email: data?['email'] ?? '',
        );
      }

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Анонимный вход
  Future<String?> signInAsGuest() async {
    try {
      await _auth.signInAnonymously();
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Выход
  Future<void> signOut() async {
    await _auth.signOut();
    await _localStorage.clearUserData();
    notifyListeners();
  }

  // Ручная синхронизация
  Future<String> syncUserData() async {
    final user = _auth.currentUser;
    if (user == null || user.isAnonymous) return "Not logged in.";

    final data = await _localStorage.getUserData();
    if (data.isEmpty) return "No local data to sync.";

    await _firestore.collection('users').doc(user.uid).set(data, SetOptions(merge: true));
    return "Data synced successfully.";
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
