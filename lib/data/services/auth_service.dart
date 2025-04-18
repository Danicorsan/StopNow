import 'package:stopnow/data/models/user.dart';
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

  // Obtener el usuario actual
  UserModel? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final json = user.userMetadata ?? {};

    return UserModel(
      nombreUsuario: json['nombre_usuario'] as String,
      fotoPerfil: json['foto_perfil'] as String,
      fechaDejarFumar: DateTime.parse(json['fecha_dejar_fumar'] as String),
      cigarrosAlDia: json['cigarros_al_dia'] as int,
      cigarrosPorPaquete: json['cigarros_por_paquete'] as int,
      precioPaquete: (json['precio_paquete'] as num).toDouble(),
    );
  }
}
