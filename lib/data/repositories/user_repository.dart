// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:path/path.dart';
import 'package:stopnow/data/dao/user_dao.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/data/models/reading_model.dart';
import 'package:stopnow/data/models/user_model.dart';
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

  static String getId() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }
    return userId;
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

  static Future<String> uploadProfileImage(File imageFile) async {
    try {
      final userId =
          supabase.auth.currentUser?.id ?? Exception('Usuario no autenticado');

      final fileExt = extension(imageFile.path);
      final fileName = 'profile_$userId$fileExt';

      // Subir imagen
      await supabase.storage
          .from('avatars')
          .upload(fileName, imageFile, fileOptions: FileOptions(upsert: true));

      final signedUrl = await supabase.storage
          .from('avatars')
          .createSignedUrl(fileName, 60 * 60 * 24 * 365); // 1 año en segundos

      return signedUrl;
    } catch (e) {
      print('Error al subir imagen: $e');
      throw Exception('Error al subir la imagen de perfil');
    }
  }

  static Future<bool> subirObjetivo(GoalModel goal) async {
    try {
      await UserDao.insertarObjetivo(
        idUsuario: goal.usuarioId,
        nombreObjetivo: goal.nombre,
        descripcion: goal.descripcion,
        precio: goal.precio,
      );
      return true;
    } catch (e) {
      print('Error al subir objetivo: $e');
      return false;
    }
  }

  static Future<BaseResult> obtenerObjetivos() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return BaseResultError('Usuario no autenticado');
      }

      final response = await UserDao.obtenerObjetivos(userId);
      if (response.isEmpty) {
        return BaseResultSuccess([]);
      }

      return BaseResultSuccess(response);
    } catch (e) {
      return BaseResultError(e.toString());
    }
  }

  static Future<BaseResult> borrarObjetivo(String id) async {
    try {
      await UserDao.borrarObjetivo(
        id: id,
      );
      return BaseResultSuccess(true);
    } catch (e) {
      print('Error al borrar objetivo: $e');
      return BaseResultError('Error al borrar objetivo: $e');
    }
  }

  static Future<BaseResult> reiniciarFechaFumar() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return BaseResultError('Usuario no autenticado');
      }

      final response = await UserDao.actualizarFechaDejarFumar();

      return BaseResultSuccess(response);
    } catch (e) {
      return BaseResultError(e.toString());
    }
  }

  // Metodo para traer articulos de lectura
  static Future<List<ReadingModel>> traerArticulos() async {
    try {
      final response = await UserDao.obtenerArticulos();

      if (response.isEmpty) {
        return [];
      }

      return response
          .map<ReadingModel>((a) => ReadingModel.fromMap(a))
          .toList();
    } catch (e) {
      print('Error al cargarrrrrrrrrrrrrrrrrrrrrrrrrrrrrr artículos: $e');
      return [];
    }
  }

  static Future<BaseResult> enviarMensaje(
      String texto, String nombreUsuario, String fotoPerfil) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return BaseResultError('Usuario no autenticado');
      }

      final response =
          await UserDao.insertarMensaje(texto, nombreUsuario, fotoPerfil);

      return BaseResultSuccess(response);
    } catch (e) {
      return BaseResultError(e.toString());
    }
  }

  static Future<BaseResult> actualizarObjetivo({
    required String id,
    required String nombreNuevo,
    required String descripcionNueva,
    required double precioNuevo,
  }) async {
    try {
      await UserDao.actualizarObjetivo(
        id: id,
        nombreNuevo: nombreNuevo,
        descripcionNueva: descripcionNueva,
        precioNuevo: precioNuevo,
      );
      return BaseResultSuccess(true);
    } catch (e) {
      print('Error al actualizar objetivo: $e');
      return BaseResultError('Error al actualizar objetivo: $e');
    }
  }
}
