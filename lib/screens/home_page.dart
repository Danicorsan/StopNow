import 'package:flutter/material.dart';
import 'package:stopnow/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => _auth.signOut(),
          child: const Text("Salir"),
        )
      ],
    );
  }
}
