import 'package:flutter/material.dart';
import 'package:stopnow/data/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  static final AuthService _authService = AuthService();

  static Future<bool> login(String correo, String pass) async {
    try {
      final response =
          await _authService.signIn(correo, pass);
      if (response.user == null) {
        return false;
      }
    } catch (e) {
      return false;
    }

    return true;

  }

  /*
  Future<bool> login(User usuario) async {
    try {
      final response =
          await _authService.signIn(usuario.email, usuario.password);
      if (response.user == null) {
        return false;
      }
    } catch (e) {
      return BaseResult.Error(e);
    }

    return BaseResult.Success(true);

  }
  */

}
