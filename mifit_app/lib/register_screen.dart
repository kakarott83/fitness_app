import 'auth_service.dart';
import 'package:flutter/material.dart';
/*import 'package:supabase_flutter/supabase_flutter.dart';*/

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  // Funktion für die Registrierung
  void _handleSignUp() async {
    try {
      await _authService.signUp(
        _emailController.text,
        _passwordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account erstellt! Logge dich nun ein.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Willkommen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-Mail'),
              keyboardType:
                  TextInputType.emailAddress, // Optimiert für @ Zeichen
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Registrier-Button
            ElevatedButton(
              onPressed: _handleSignUp,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Registrieren'),
            ),

            const SizedBox(height: 10),

            // NEU: Login-Button
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Geht zurück zum LoginScreen
              child: const Text('Bereits ein Konto? Zum Login'),
            ),
          ],
        ),
      ),
    );
  }
}
