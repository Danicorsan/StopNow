// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/user_avatar.dart';
import 'package:stopnow/ui/calm/calm_page.dart';

Drawer baseDrawer(BuildContext context) {
  final userProvider =
      Provider.of<UserProvider>(context, listen: false).currentUser;
  return Drawer(
    child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 12, 71, 99),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 80, width: 80, child: UserAvatar()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                    ),
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
