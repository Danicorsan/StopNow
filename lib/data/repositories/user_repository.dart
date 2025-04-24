import 'package:stopnow/data/dao/user_dao.dart';
import 'package:stopnow/data/models/user.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  static final AuthService _authService = AuthService();
  static final supabase = Supabase.instance.client;

  // Método para iniciar sesión
  static Future<BaseResult> login(String correo, String pass) async {
    try {
      final response = await _authService.signIn(correo, pass);
      if (response.user == null) {
        return BaseResultError("Usuario o contraseña incorrectos");
      }
    } catch (e) {
      return BaseResultError(e.toString());
    }

    return BaseResultSuccess(true);
  }

  // Metodo para registrarse
  static Future<BaseResult> register(
    String correo,
    String pass,
    String nombreUsuario,
    String fotoEmail,
    DateTime fechaDejarFumar,
    int cigarrosAlDia,
    int cigarrosPorPaquete,
    double precioPaquete,
  ) async {
    try {
      final response = await _authService.signUp(correo, pass);

      final userId = response.user?.id;
      if (userId == null) {
        return BaseResultError('No se pudo registrar el usuario.');
      }

      await UserDao.insertarUsuario(
        id: userId,
        nombreUsuario: nombreUsuario,
        fotoEmail: fotoEmail,
        fechaDejarFumar: fechaDejarFumar,
        cigarrosAlDia: cigarrosAlDia,
        cigarrosPorPaquete: cigarrosPorPaquete,
        precioPaquete: precioPaquete,
      );

      return BaseResultSuccess(true);
    } catch (e) {
      return BaseResultError(e.toString());
    }
  }

  //metodo para obtener el usuario actual
  static Future<UserModel?> usuarioActual() async {
    final user = await _authService.getCurrentUser();
    if (user == null) return null;
    return user;
  }
}
