// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/register/register_state.dart';

class RegisterProvider extends ChangeNotifier {
  var registerState = RegisterState.initial;

  //formkey
  String email = '';
  String password = '';
  String confirmPassword = '';

  var errorMessage = "";

  Future<void> register() async {
    registerState = RegisterState.loading;
    print(email);
    print(password);
    print(registerState);

    notifyListeners();

    try {
      await UserRepository.register(email, password).then((value) {
        if (value is BaseResultError) {
          registerState = RegisterState.error;
          errorMessage = value.message;
          print("El obketp esta dentro de error $errorMessage");
          notifyListeners();
        } else if (value is BaseResultSuccess) {
          registerState = RegisterState.success;
          notifyListeners();
          return;
        }
      });
    } catch (e) {
      registerState = RegisterState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  void setCorreo(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }
}
