import 'package:flutter/material.dart';
import 'package:stopnow/data/models/user_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/dao/user_dao.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? userToShow;
  bool isLoading = false;
  bool isCurrentUser = false;

  Future<void> loadUser(BuildContext context, {String? userId}) async {
    isLoading = true;
    notifyListeners();

    // Siempre pide el usuario actualizado al repositorio
    final user = userId == null
        ? await UserRepository.usuarioActual()
        : await UserDao.traerUsuario(userId);

    userToShow = user;
    isLoading = false;
    notifyListeners();
  }
}
