// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/data/services/flutter_local_notifications.dart';
import 'package:stopnow/data/shared_preferences/shared_preferences.dart';
import 'package:stopnow/ui/login/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginProvider extends ChangeNotifier {
  String errorMessage = "";
  String correo = "";
  String contrasenia = "";

  LoginState loginState = LoginState.initial;

  Future<void> login(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    loginState = LoginState.loading;
    notifyListeners();

    if (correo.isEmpty || contrasenia.isEmpty) {
      loginState = LoginState.error;
      errorMessage = localizations.porfavorIngreseUsuarioYContrasenia;
      notifyListeners();
      return;
    }

    var result = await UserRepository.login(correo, contrasenia);

    if (result is BaseResultError) {
      loginState = LoginState.error;
      errorMessage = localizations.revisaCorreoyContrasenia;
      notifyListeners();
      return;
    } else if (result is BaseResultSuccess) {
      //Obtenemos el usuario actual
      final user = await UserRepository.usuarioActual();
      if (user == null) {
        loginState = LoginState.error;
        errorMessage = localizations.noSePudoObtenerElUsuarioActual;
        notifyListeners();
        return;
      }
      
      // Programar notificaciones de logros al iniciar sesión
      await AchievementsNotificationService.scheduleAchievementNotifications(
        fechaDejarFumar: user.fechaDejarFumar,
        localizations: localizations,
      );

      // Guardar el usuario en el UserProvider
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      await saveUserStatus(true); // Solo guardamos el booleano
      loginState = LoginState.success;

      notifyListeners();
      return;
    }
  }

  void setCorreo(String correo) {
    this.correo = correo;
    notifyListeners();
  }

  void setPassword(String pass) {
    contrasenia = pass;
    notifyListeners();
  }
}
