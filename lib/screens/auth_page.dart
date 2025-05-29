import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'auth_wrapper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
  bool isLoading = false;

  void _submit() async {
    if (isLoading) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill all required fields.');
      return;
    }

    if (!email.contains('@')) {
      _showError('Please enter a valid email.');
      return;
    }

    if (password.length < 6) {
      _showError('Password should be at least 6 characters.');
      return;
    }
final connectivityResult = await Connectivity().checkConnectivity();
if (connectivityResult == ConnectivityResult.none) {
  _showError('❌ No internet connection. Please connect to the internet and try again.');
  setState(() => isLoading = false);
  return;
}
    setState(() {
      isLoading = true;
    });

    final auth = Provider.of<AuthService>(context, listen: false);

    try {
      String? result;
      if (isLogin) {
        result = await auth.loginWithEmail(email, password);
      } else {
        final name = _nameController.text.trim();
        final age = _ageController.text.trim();

        if (name.isEmpty || age.isEmpty) {
          _showError('Please fill all fields.');
          setState(() => isLoading = false);
          return;
        }

        result = await auth.registerWithEmail(
          email,
          password,
          name: name,
          age: age,
        );
      }

      if (result != null) {
        _showError(result);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }
    } catch (e) {
      _showError('Something went wrong. Try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _signInAsGuest() async {
  if (isLoading) return;

  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    _showError('❌ No internet connection. Please connect to the internet and try again.');
    return;
  }
    setState(() {
      isLoading = true;
    });

    final auth = Provider.of<AuthService>(context, listen: false);

    try {
      String? result = await auth.signInAsGuest();

      if (result != null) {
        _showError(result);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }
    } catch (e) {
      _showError('Error signing in as guest.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
              if (isLoading)
                const Center(child: CircularProgressIndicator()),
              if (!isLoading)
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: Text(isLogin ? 'Login' : 'Register'),
                ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                child: Text(isLogin
                    ? 'Don\'t have an account? Register'
                    : 'Already have an account? Login'),
              ),
              const Divider(),
              if (!isLoading)
                ElevatedButton(
                  onPressed: isLoading ? null : _signInAsGuest,
                  child: const Text('Continue as Guest'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
