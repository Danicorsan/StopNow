import 'package:stopnow/data/dao/user_dao.dart';
import 'package:stopnow/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio de autenticación que encapsula las funciones de login, registro y logout
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // Registro de usuario
  Future<AuthResponse> signUp(String email, String password) async {
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

  // Obtener el email del usuario actual
  String? getEmail() {
    final user = _client.auth.currentUser?.email ?? "No email";
    return user;
  }

  // Obtener el usuario actual desde la base de datos
  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    print(user.id); // Imprime el ID

    final usuarioActual = await UserDao.traerUsuario(
        user.id); // Llama al DAO para obtener el usuario

    return usuarioActual; // Convierte el resultado a un modelo de usuario
  }
}
