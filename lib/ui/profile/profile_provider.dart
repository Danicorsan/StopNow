// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stopnow/data/helper/local_database_helper.dart';
import 'package:stopnow/data/models/user_model.dart';
import 'package:stopnow/data/dao/user_dao.dart';
import 'package:stopnow/data/repositories/user_repository.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? userToShow;
  bool isLoading = false;
  bool isCurrentUser = false;

  Future<void> loadUser(BuildContext context, {String? userId}) async {
    isLoading = true;
    notifyListeners();

    // Si no tiene conexion, carga el usuario de sqlite
    final conexion = await UserRepository.tienesConexion();

    final user = userId == null
        ? conexion
            ? await UserRepository.usuarioActual()
            : await LocalDbHelper.getUserProgress()
        : await UserDao.traerUsuario(userId);

    userToShow = user;
    isLoading = false;
    notifyListeners();
  }
}
