// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stopnow/services/auth_service.dart';

class LoginProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String email = '';
  String password = '';
  bool isLoading = false;
  String? errorMessage;

  Future<void> login(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.signIn(email, password);
      if (response.user == null) {
        errorMessage = 'Credenciales incorrectas';
      }
    } catch (e) {
      errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: const Color.fromARGB(255, 124, 23, 15),
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
