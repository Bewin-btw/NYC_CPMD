import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'auth_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ⬅️ добавь это

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = Provider.of<AuthService>(context, listen: false);

    final t = AppLocalizations.of(context)!; // ⬅️ удобное сокращение

    return Scaffold(
      appBar: AppBar(title: Text(t.profileTitle)), // <-- добавь этот ключ в .arb файл
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text(t.noUserData)); // <-- добавь этот ключ
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(t.email),
                subtitle: Text(data['email'] ?? 'N/A'),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(t.name),
                subtitle: Text(data['name'] ?? 'N/A'),
              ),
              ListTile(
                leading: const Icon(Icons.cake),
                title: Text(t.age),
                subtitle: Text(data['age'] ?? 'N/A'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(AppLocalizations.of(context)!.logout),
                onTap: () async {
                  await authService.signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthPage()),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
