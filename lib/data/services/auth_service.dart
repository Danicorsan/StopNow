import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio de autenticación que encapsula las funciones de login, registro y logout
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // Registro de usuario
  Future<AuthResponse>  signUp(String email, String password) async {
    final response =
        await _client.auth.signUp(email: email, password: password);
    return response;
  }

  // Inicio de sesión
  Future<AuthResponse> signIn(String email, String password) async {
    final response =
        await _client.auth.signInWithPassword(email: email, password: password);
    return response;
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  String? getEmail() {
    final user = _client.auth.currentUser?.email ?? "No email";
    return user;
  }
}
