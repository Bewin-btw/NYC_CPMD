import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

      // Сохраняем доп. информацию в Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'age': age,
        'email': email.trim(),
      });

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

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

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
    notifyListeners();
  }

  // Поток изменений авторизации
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
