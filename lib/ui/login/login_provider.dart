// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stopnow/data/models/user.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/data/services/auth_service.dart';
import 'package:stopnow/ui/login/login_state.dart';

class LoginProvider extends ChangeNotifier {
  //State en kotlin era un archivo aparte
  String errorMessage = "";
  String correo = "";
  String contrasenia = "";

  LoginState loginState = LoginState.initial;

  Future<void> login() async {
    loginState = LoginState.loading;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 5000));

    if (correo.isEmpty || contrasenia.isEmpty) {
      loginState = LoginState.error;
      errorMessage = "Por favor, ingrese su correo y contraseña";
      notifyListeners();
      return;
    }

    var result = await UserRepository.login(correo, contrasenia);

    if (result is BaseResultError) {
      loginState = LoginState.error;
      errorMessage = result.message;
      notifyListeners();
      return;
    } else if (result is BaseResultSuccess) {
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
