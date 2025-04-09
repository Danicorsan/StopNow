// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stopnow/data/models/user.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/data/services/auth_service.dart';

class LoginProvider extends ChangeNotifier {
  //State en kotlin era un archivo aparte
  String? correo;
  String? contrasenia;

  var state = false;

  Future<void> login() async {
    var result = await UserRepository.login(correo ?? "", contrasenia ?? "");

    if (result == true) {
      state = true;
    } else {
      state = false;
    }
    notifyListeners();
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
