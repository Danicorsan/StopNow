import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart';
import 'package:stopnow/data/dao/user_dao.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/data/models/reading_model.dart';
import 'package:stopnow/data/models/user_model.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/services/auth_service.dart';
import 'package:stopnow/data/services/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserRepository {
  static final AuthService _authService = AuthService();
  static final supabase = Supabase.instance.client;

  /// Método para iniciar sesión
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

  /// Metodo para obtener el ID del usuario actual
  static String getId() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }
    return userId;
  }

  /// Metodo para registrarse
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
      // Miramos si hay un usuario con el mismo nombre de usuario
      final nombres =
          await UserDao.nombresDeUsuarios(nombreUsuario: nombreUsuario);
      if (nombres.isNotEmpty) {
        return BaseResultError('duplicate key value');
      }

      final response = await _authService.signUp(correo, pass);

      final userId = response.user?.id;
      if (userId == null) {
        return BaseResultError('No se pudo registrar el usuario.');
      }

      try {
        await UserDao.insertarUsuario(
          id: userId,
          nombreUsuario: nombreUsuario,
          fotoEmail: fotoEmail,
          fechaDejarFumar: fechaDejarFumar,
          cigarrosAlDia: cigarrosAlDia,
          cigarrosPorPaquete: cigarrosPorPaquete,
          precioPaquete: precioPaquete,
        );
      } catch (e) {
        return BaseResultError('Error al guardar los datos del usuario.');
      }

      return BaseResultSuccess(true);
    } catch (e) {
      return BaseResultError(e.toString());
    }
  }

  /// Metodo para obtener el usuario actual
  static Future<UserModel?> usuarioActual() async {
    final user = await _authService.getCurrentUser();
    if (user == null) return null;
    return user;
  }

  /// Metodo para subir la imagen de perfil del usuario
  static Future<BaseResult> subirImagenPerfil(File imageFile) async {
    try {
      final fileExt = extension(imageFile.path);
      final fecha = DateTime.now().millisecondsSinceEpoch;
      final uuid = const Uuid().v4();
      final fileName = 'avatar_${uuid}_$fecha$fileExt';

      await supabase.storage
          .from('avatars')
          .upload(fileName, imageFile, fileOptions: const FileOptions(upsert: true));

      final signedUrl = await supabase.storage
          .from('avatars')
          .createSignedUrl(fileName, 60 * 60 * 24 * 365); // 1 año

      return BaseResultSuccess(signedUrl);
    } catch (e) {
      return BaseResultError('Error al subir la imagen de perfil: $e');
    }
  }

  /// Metodo para subir un objetivo
  static Future<BaseResult> subirObjetivo(GoalModel goal) async {
    try {
      await UserDao.insertarObjetivo(
        idUsuario: goal.usuarioId,
        nombreObjetivo: goal.nombre,
        descripcion: goal.descripcion,
        precio: goal.precio,
      );
      return BaseResultSuccess(true);
    } catch (e) {
      print('Error al subir objetivo: $e');
      return BaseResultError('Error al subir objetivo: $e');
    }
  }

  /// Metodo para traer los objetivos del usuario
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

  /// Metodo para borrar un objetivo
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

  /// Metodo para actualizar la fecha de dejar de fumar
  static Future<BaseResult> reiniciarFechaFumar(
      AppLocalizations? localizations) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        return BaseResultError('Usuario no autenticado');
      }
      DateTime fechaDejarFumar = DateTime.now();
      final response = await UserDao.actualizarFechaDejarFumar();

      // Programar notificaciones
      if (localizations != null) {
        await AchievementsNotificationService.programarNotificacionLogro(
          fechaDejarFumar: fechaDejarFumar,
          localizations: localizations,
        );
      }

      return BaseResultSuccess(response);
    } catch (e) {
      return BaseResultError(e.toString());
    }
  }

  /// Metodo para traer articulos de lectura
  static Future<BaseResult> traerArticulos(String locale) async {
    try {
      final response = await UserDao.obtenerArticulos(locale);

      if (response.isEmpty) {
        return BaseResultError('No se encontraron artículos de lectura');
      }

      return BaseResultSuccess(
          response.map<ReadingModel>((a) => ReadingModel.fromMap(a)).toList());
    } catch (e) {
      print('Error al cargarrrrrrrrrrrrrrrrrrrrrrrrrrrrrr artículos: $e');
      return BaseResultError('Error al cargar artículos: $e');
    }
  }

  /// Metodo para enviar un mensaje
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

  /// Metodo para actualizar un objetivo
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

  /// Metodo para actualizar el perfil del usuario
  static Future<BaseResult> actualizarPerfilUsuario({
    required String id,
    required String nombreUsuario,
    required String? fotoPerfil,
    required DateTime fechaDejarFumar,
    required int cigarrosAlDia,
    required int cigarrosPorPaquete,
    required double precioPaquete,
    AppLocalizations? localizations,
  }) async {
    try {
      await UserDao.actualizarPerfilUsuario(
        id: id,
        nombreUsuario: nombreUsuario,
        fotoPerfil: fotoPerfil,
        fechaDejarFumar: fechaDejarFumar,
        cigarrosAlDia: cigarrosAlDia,
        cigarrosPorPaquete: cigarrosPorPaquete,
        precioPaquete: precioPaquete,
      );

      // Reprograma las notificaciones si se pasa localizations
      if (localizations != null) {
        await AchievementsNotificationService.programarNotificacionLogro(
          fechaDejarFumar: fechaDejarFumar,
          localizations: localizations,
        );
      }

      return BaseResultSuccess(true);
    } catch (e) {
      return BaseResultError(e.toString());
    }
  }

  /// Metodo para obtener los mensajes del chat
  static Future<BaseResult> getMensajes() async {
    try {
      final response = await UserDao.obtenerMensajes();

      return BaseResultSuccess(response);
    } catch (e) {
      return BaseResultError('Error al obtener mensajes: $e');
    }
  }

  /// Metodo para actualizar el nombre de usuario y foto de perfil en los mensajes del chat
  static Future<BaseResult> actualizarMensajesNombreYFoto({
    required String userId,
    required String? nuevaFotoPerfil,
    required String nuevoNombreUsuario,
  }) async {
    try {
      await UserDao.actualizarMensajesNombreYFoto(
        userId: userId,
        nuevaFotoPerfil: nuevaFotoPerfil,
        nuevoNombreUsuario: nuevoNombreUsuario,
      );
      return BaseResultSuccess(true);
    } catch (e) {
      return BaseResultError('Error al actualizar mensajes: $e');
    }
  }

  /// Metodo para borrar la foto de perfil antigua
  static Future<BaseResult> borrarFotoPerfilAntigua(String urlFoto) async {
    try {
      await UserDao.borrarFotoPerfilAntigua(urlFoto);
      return BaseResultSuccess(true);
    } catch (e) {
      return BaseResultError('Error al borrar la foto antigua: $e');
    }
  }

  static Future<bool> tienesConexion() async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity.first == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  static Future<void> cancelAllNotifications() async {
    await AchievementsNotificationService.cancelarTodas();
  }
}
