// ignore_for_file: avoid_print

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
  File? _profileImageFile;

  var errorMessage = "";

  Future<void> setProfileImage(File imageFile) async {
    try {
      // Supón que tienes un método para subir y obtener la URL
      final uploadedImageUrl =
          await UserRepository.uploadProfileImage(imageFile);
      fotoEmail = uploadedImageUrl;
      print(fotoEmail);
      notifyListeners();
    } catch (e) {
      print('Error al subir imagen: $e');
    }
  }

  // Modifica el método register
  Future<void> register() async {
    registerState = RegisterState.loading;
    notifyListeners();

    try {
      String imageUrl = '';

      // Subir imagen primero si existe
      if (_profileImageFile != null) {
        imageUrl = await UserRepository.uploadProfileImage(_profileImageFile!);
      }

      print(
          "\n\n\n\n\n\n\n\n\n\n\n\nimageUrl: $imageUrl\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
      print(
          "\n\n\n\n\n\n\n\n\n\n\n\nimageUrl: $fotoEmail\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");

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
        registerState = RegisterState.error;
        errorMessage = result.message;
      } else {
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
