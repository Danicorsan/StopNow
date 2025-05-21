import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/user_avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//TODO: Si esta en la pantalla que pulsa el icono de la barra de navegacion, no se cierra el drawer.
Drawer baseDrawer(BuildContext context) {
  final user = Provider.of<UserProvider>(context, listen: false).currentUser;
  final localizations = AppLocalizations.of(context)!;

  return Drawer(
    child: Column(
      children: <Widget>[
        // Encabezado del Drawer
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF608AAE), Color(0xFF153866)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: UserAvatar(),
                ),
                Text(
                  user?.nombreUsuario ?? localizations.usuario,
                  style: TextStyle(
                    color: Colors.white,
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
              ),
              _buildDrawerItem(
                context,
                icon: Icons.person,
                title: localizations.perfil,
                route: AppRoutes.profile,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.group,
                title: localizations.comunidad,
                route: AppRoutes.chat, // Cambia según tu ruta
              ),
              _buildDrawerItem(
                context,
                icon: Icons.interests,
                title: localizations.objetivos,
                route: AppRoutes.goals,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.local_attraction_sharp,
                title: localizations.logros,
                route: AppRoutes.achievement, // Cambia según tu ruta
              ),
            ],
          ),
        ),

        const Divider(),

        // Ajustes
        _buildDrawerItem(
          context,
          icon: Icons.settings,
          title: localizations.ajustes,
          route: AppRoutes.settingsPage,
        ),
      ],
    ),
  );
}

Widget _buildDrawerItem(BuildContext context,
    {required IconData icon, required String title, required String route}) {
  return ListTile(
    leading: Icon(
      icon,
      color: const Color(0xFF153866),
    ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
    onTap: () async {
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 250));
      Navigator.pushNamed(context, route);
    },
  );
}
