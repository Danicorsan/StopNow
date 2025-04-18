import 'package:flutter/material.dart';
import 'package:stopnow/data/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Bienvenido a la pantalla principal"),
          TextButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Salir"),
          ),
        ],
      )),
    );
  }
}
