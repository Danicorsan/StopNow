// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';

class SettingsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> actualizarPerfil({
    required String id,
    required String nombreUsuario,
    required String? fotoPerfil,
    required DateTime fechaDejarFumar,
    required int cigarrosAlDia,
    required int cigarrosPorPaquete,
    required double precioPaquete,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();
    final urlFotoAntigua = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        ?.fotoPerfil;

    final result = await UserRepository.actualizarPerfilUsuario(
      id: id,
      nombreUsuario: nombreUsuario,
      fotoPerfil: fotoPerfil,
      fechaDejarFumar: fechaDejarFumar,
      cigarrosAlDia: cigarrosAlDia,
      cigarrosPorPaquete: cigarrosPorPaquete,
      precioPaquete: precioPaquete,
    );

    if (result is BaseResultSuccess) {
      final user = await UserRepository.usuarioActual();
      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(user);
      }
      final exit = await UserRepository.actualizarMensajesNombreYFoto(
        userId: UserRepository.getId(),
        nuevaFotoPerfil: fotoPerfil,
        nuevoNombreUsuario: nombreUsuario,
      );
      if (exit is BaseResultError) {
        errorMessage = exit.message;
        isLoading = false;
        notifyListeners();
        return false;
      }
      final user2 = await UserRepository.usuarioActual();
      if (user2 != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(user2);
      }
      if (urlFotoAntigua != null && urlFotoAntigua.isNotEmpty) {
        final exitoBorrado =
            await UserRepository.borrarFotoPerfilAntigua(urlFotoAntigua);
        if (exitoBorrado is BaseResultError) {
          buildErrorMessage(exitoBorrado.message, context);
          isLoading = false;
          notifyListeners();
          return false;
        }
      }
      errorMessage = null;
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      errorMessage = result is BaseResultError ? result.message : null;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarFotoPerfil(
      File imageFile, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final result = await UserRepository.uploadProfileImage(imageFile);

    //final cambiar = await UserRepository.cambiarTodoFotoPerfil(imageFile);

    if (result is BaseResultSuccess) {
      final fotoPerfilUrl = result.data as String;
      // Actualiza la URL en la tabla de usuarios
      final user =
          Provider.of<UserProvider>(context, listen: false).currentUser;
      if (user == null) {
        errorMessage = "Usuario no autenticado";
        isLoading = false;
        notifyListeners();
        return false;
      }
      final updateResult = await UserRepository.actualizarPerfilUsuario(
        id: UserRepository.getId(),
        nombreUsuario: user.nombreUsuario,
        fotoPerfil: fotoPerfilUrl,
        fechaDejarFumar: user.fechaDejarFumar,
        cigarrosAlDia: user.cigarrosAlDia,
        cigarrosPorPaquete: user.cigarrosPorPaquete,
        precioPaquete: user.precioPaquete,
      );
      if (updateResult is BaseResultSuccess) {
        // Refresca el usuario en el provider
        final updatedUser = await UserRepository.usuarioActual();
        if (updatedUser != null) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(updatedUser);
        }
        errorMessage = null;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage =
            updateResult is BaseResultError ? updateResult.message : null;
        isLoading = false;
        notifyListeners();
        return false;
      }
    } else {
      errorMessage = result is BaseResultError ? result.message : null;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
