import 'package:flutter/material.dart';

/// Tema claro para la aplicación.
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF153866),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF153866),
    foregroundColor: Colors.white,
    elevation: 4,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF153866),
    secondary: Color(0xFF608AAE),
    background: Colors.white,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF153866),
    foregroundColor: Colors.white,
  ),
  cardColor: Colors.white,
  dividerColor: const Color(0xFF608AAE),
  iconTheme: const IconThemeData(color: Color(0xFF153866)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF153866)),
    bodyMedium: TextStyle(color: Color(0xFF153866)),
    titleLarge: TextStyle(color: Color(0xFF153866)),
    titleMedium: TextStyle(color: Color(0xFF608AAE)),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF153866),
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
  ),
);

/// Tema oscuro para la aplicación.
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF1E3A5F),
  scaffoldBackgroundColor:
      const Color(0xFF0D1524),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E3A5F),
    foregroundColor: Colors.white,
    elevation: 4,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF3B82F6),
    secondary: Color(0xFF60A5FA),
    background: Color(0xFF0D1524),
    surface: Color(0xFF1C2A3A),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF3B82F6),
    foregroundColor: Colors.white,
  ),
  cardColor: const Color(0xFF1C2A3A),
  dividerColor: const Color(0xFF334155),
  iconTheme: const IconThemeData(color: Color(0xFF60A5FA)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Color(0xFF93C5FD)),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Color(0xFFBFDBFE)),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF3B82F6),
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF1C2A3A),
  ),
);
