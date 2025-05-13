// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopnow/routes/app_routes.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // Verifica si el usuario ya tiene una cuenta
    final hasAccount = prefs.getBool('hasAccount') ?? false;

    if (hasAccount) {
      // Si tiene cuenta, redirige a la página principal
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      // Si no tiene cuenta, redirige a la página de bienvenida
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF608AAE),
        ), // Muestra un indicador de carga mientras se verifica
      ),
    );
  }
}