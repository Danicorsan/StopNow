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
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.white),
        title: const Text(
          'Inicio',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 21, 56, 102),
        elevation: 0,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Bienvenido a la pantalla principal}"),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 40.0, right: 40.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 219, 225, 225),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 50,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("0"),
                        Text("12"),
                        Text("24"),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Años"),
                        Text("Meses"),
                        Text("Dias"),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
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
