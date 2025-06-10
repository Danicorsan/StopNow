import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/register/register_state.dart';

class RegisterProvider extends ChangeNotifier {
  var registerState = RegisterState.initial;

  String email = '';
  String password = '';
  String confirmPassword = '';
  String nombreUsuario = '';
  String fotoEmail = '';
  DateTime fechaDejarFumar = DateTime.now();
  int cigarrosAlDia = 0;
  int cigarrosPorPaquete = 0;
  double precioPaquete = 0.0;
  bool cargandoImagen = false;

  var errorMessage = "";

  Future<void> setProfileImage(File? imageFile) async {
    try {
      if (imageFile == null) {
        return;
      }

      cargandoImagen = true;

      final uploadedImageUrl =
          await UserRepository.uploadProfileImage(imageFile);

      if (uploadedImageUrl is BaseResultSuccess) {
        fotoEmail = uploadedImageUrl.data as String;
        cargandoImagen = false;
        notifyListeners();
      }
    } catch (e) {
      cargandoImagen = false;
      notifyListeners();
    }
  }

  
  Future<void> register() async {
    registerState = RegisterState.loading;
    notifyListeners();

    try {
      await Future.any([
        () async {
          while (cargandoImagen) {
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }(),
        Future.delayed(const Duration(seconds: 20), () {
          throw TimeoutException("Error al subir la imagen");
        }),
      ]);

      final result = await UserRepository.register(
          email,
          password,
          nombreUsuario,
          fotoEmail,
          fechaDejarFumar,
          cigarrosAlDia,
          cigarrosPorPaquete,
          precioPaquete);

      if (result is BaseResultError) {
        errorMessage = result.message;
        registerState = RegisterState.error;
      } else if (result is BaseResultSuccess) {
        registerState = RegisterState.success;
      }
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

  void setNombreUsuario(String value) {
    nombreUsuario = value;
    notifyListeners();
  }

  void setFotoEmail(String value) {
    fotoEmail = value;
    notifyListeners();
  }

  void setFechaDejarFumar(DateTime value) {
    fechaDejarFumar = value;
    notifyListeners();
  }

  void setCigarrosAlDia(int value) {
    cigarrosAlDia = value;
    notifyListeners();
  }

  void setCigarrosPorPaquete(int value) {
    cigarrosPorPaquete = value;
    notifyListeners();
  }

  void setPrecioPaquete(double value) {
    precioPaquete = value;
    notifyListeners();
  }
}
