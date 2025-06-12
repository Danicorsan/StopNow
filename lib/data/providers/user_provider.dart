import 'package:flutter/material.dart';
import 'package:stopnow/data/helper/local_database_helper.dart';
import 'package:stopnow/data/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserProvider({UserModel? usuarioInicial}) {
    _currentUser = usuarioInicial;
  }

  /// Obtiene el usuario actual.
  UserModel? get currentUser => _currentUser;

  /// Actualiza el usuario actual y notifica.
  void setUser(UserModel user) {
    _currentUser = user;
    // Guarda también en SQLite para offline
    LocalDbHelper.saveUserProgress(user);
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
