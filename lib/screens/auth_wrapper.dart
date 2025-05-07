import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'auth_page.dart';
import '../main.dart'; // MainNavigation
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Загружаем настройки темы и языка
      Future.microtask(() async {
        await Provider.of<ThemeProvider>(context, listen: false).loadUserThemeFromFirebase();
        await Provider.of<LocaleProvider>(context, listen: false).loadUserLanguageFromFirebase();
      });

      return const MainNavigation();
    } else {
      return const AuthPage();
    }
  }
}
