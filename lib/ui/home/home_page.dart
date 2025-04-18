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
          child: TextButton(
        onPressed: () {
          _auth.signOut();
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home Page"),
            SizedBox(
              height: 20,
            ),
            Text("Salir"),
          ],
        ),
      )),
    );
  }
}
