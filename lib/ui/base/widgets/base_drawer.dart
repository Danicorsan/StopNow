// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stopnow/routes/app_routes.dart';

Drawer baseDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                child: FlutterLogo(),
              ),
              Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Inicio'),
          onTap: () {
            Navigator.pushReplacementNamed(
                context, '/home'); // Cierra el drawer
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Perfil'),
          onTap: () async {
            Navigator.pop(context); // Cierra el Drawer primero
            await Future.delayed(const Duration(milliseconds: 250)); // Espera animación
            Navigator.pushNamed(
                context, AppRoutes.profile); // Navega luego
          },
        ),
        ListTile(
          leading: const Icon(Icons.group),
          title: const Text('Comunidad'),
          onTap: () {
            Navigator.pop(context); // Cierra el drawer
          },
        ),
        ListTile(
          leading: const Icon(Icons.interests),
          title: const Text('Objetivos'),
          onTap: () {
            Navigator.pop(context); // Cierra el drawer
          },
        ),
        ListTile(
          leading: const Icon(Icons.local_attraction_sharp),
          title: const Text('Logros'),
          onTap: () {
            Navigator.pop(context); // Cierra el drawer
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Configuración'),
          onTap: () {
            Navigator.pop(context); // Cierra el drawer
          },
        ),
        ListTile(
          leading: const Icon(Icons.door_front_door),
          title: const Text('Salir'),
          onTap: () {
            Navigator.pop(context); // Cierra el drawer
          },
        ),
      ],
    ),
  );
}
