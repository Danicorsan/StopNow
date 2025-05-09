// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:stopnow/routes/app_routes.dart';

Drawer baseDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: const DrawerHeader(
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
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Perfil'),
                onTap: () async {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 250));
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Comunidad'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.interests),
                title: const Text('Objetivos'),
                onTap: () async {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 250));
                  Navigator.pushNamed(context, AppRoutes.goals);
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_attraction_sharp),
                title: const Text('Logros'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Ajustes'),
          onTap: () async {
            Navigator.pop(context);
            await Future.delayed(const Duration(milliseconds: 250));
            Navigator.pushNamed(context, AppRoutes.settingsPage);
          },
        ),
      ],
    ),
  );
}
