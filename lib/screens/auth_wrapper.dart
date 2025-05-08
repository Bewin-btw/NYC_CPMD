import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'auth_page.dart';
import '../main.dart'; // MainNavigation
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<void> _loadPreferences(BuildContext context) async {
    await Provider.of<ThemeProvider>(context, listen: false).loadUserThemeFromFirebase();
    await Provider.of<LocaleProvider>(context, listen: false).loadUserLanguageFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return FutureBuilder(
        future: _loadPreferences(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const MainNavigation();
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      );
    } else {
      return const AuthPage();
    }
  }
}
