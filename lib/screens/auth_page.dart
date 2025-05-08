import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'auth_wrapper.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  bool isLogin = true;
  String? error;

  void _submit() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    String? result;

    if (isLogin) {
      result = await auth.loginWithEmail(email, password);
    } else {
      final name = _nameController.text.trim();
      final age = _ageController.text.trim();
      result = await auth.registerWithEmail(
        email,
        password,
        name: name,
        age: age,
      );
    }

    if (result != null) {
      setState(() => error = result);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );
    }
  }

  void _signInAsGuest() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    String? result = await auth.signInAsGuest();

    if (result != null) {
      setState(() => error = result);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isLogin)
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
              if (!isLogin)
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () => setState(() {
                  isLogin = !isLogin;
                  error = null;
                }),
                child: Text(isLogin
                    ? 'Don\'t have an account? Register'
                    : 'Already have an account? Login'),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: _signInAsGuest,
                child: const Text('Continue as Guest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
