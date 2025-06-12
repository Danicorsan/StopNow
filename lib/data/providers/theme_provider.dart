import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _cargarTema();
  }

  /// Cambia el tema de la aplicación.
  void cambiarTema(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  /// Carga el tema guardado en SharedPreferences.
  Future<void> _cargarTema() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode');
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  /// Restablece el tema al modo por defecto del sistema.
  Future<void> porDefecto() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('isDarkMode');
    _themeMode = ThemeMode.system; // Vuelve al modo del sistema
    notifyListeners();
  }
}
