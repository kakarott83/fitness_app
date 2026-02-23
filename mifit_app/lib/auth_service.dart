import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // Registrierung
  Future<void> signUp(String email, String password) async {
    try {
      await _client.auth.signUp(email: email, password: password);
    } catch (e) {
      throw Exception('Registrierung fehlgeschlagen: $e');
    }
  }

  // Login
  Future<void> signIn(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Login fehlgeschlagen: $e');
    }
  }

  // Logout
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
