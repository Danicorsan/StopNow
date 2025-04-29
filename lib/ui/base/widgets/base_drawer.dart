import 'package:flutter/material.dart';

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
            Navigator.pop(context); // Cierra el drawer
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Perfil'),
          onTap: () {
            Navigator.pop(context); // Cierra el drawer
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
