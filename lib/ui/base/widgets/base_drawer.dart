// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/user_avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Drawer baseDrawer(BuildContext context) {
  final user = Provider.of<UserProvider>(context, listen: false).currentUser;
  final localizations = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Drawer(
    child: Column(
      children: <Widget>[
        // Encabezado del Drawer
        SizedBox(
          width: double.infinity,
          child: DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF153866), Color(0xFF608AAE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: UserAvatar(
                    avatarUrl: user?.fotoPerfil,
                  ),
                ),
                Text(
                  user?.nombreUsuario ?? localizations.usuario,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
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
              _buildDrawerItem(
                context,
                icon: Icons.home,
                title: localizations.inicio,
                route: AppRoutes.home,
                colorScheme: colorScheme,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.person,
                title: localizations.perfil,
                route: AppRoutes.profile,
                colorScheme: colorScheme,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.group,
                title: localizations.comunidad,
                route: AppRoutes.chat,
                colorScheme: colorScheme,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.interests,
                title: localizations.objetivos,
                route: AppRoutes.goals,
                colorScheme: colorScheme,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.local_attraction_sharp,
                title: localizations.logros,
                route: AppRoutes.achievement,
                colorScheme: colorScheme,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.menu_book_sharp,
                title: localizations.lecturas,
                route: AppRoutes.readings,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
        Divider(
          color: colorScheme.primary,
        ),
        // Ajustes
        _buildDrawerItem(
          context,
          icon: Icons.settings,
          title: localizations.ajustes,
          route: AppRoutes.settingsPage,
          colorScheme: colorScheme,
        ),
      ],
    ),
  );
}

Widget _buildDrawerItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String route,
  required ColorScheme colorScheme,
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: colorScheme.primary,
    ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: colorScheme.onBackground,
      ),
    ),
    onTap: () async {
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 250));
      var currentRoute = ModalRoute.of(context)?.settings.name;
      // Evitar que se navegue a la misma pantalla
      if (currentRoute != route) {
        Navigator.pushNamed(context, route);
      }
    },
  );
}
