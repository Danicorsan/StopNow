import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar("Ajustes"),
      drawer: baseDrawer(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 2,
                  color: Colors.black,
                ),
                color: const Color(0xFF608AAE),
              ),
              child: ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: const Icon(Icons.account_circle),
                title: const Text('Cuenta'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.settingsAcount);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 2,
                  color: Colors.black,
                ),
                color: const Color(0xFF608AAE),
              ),
              child: ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: const Icon(Icons.replay),
                title: const Text('Recaida'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.settingsAcount);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 2,
                  color: Colors.black,
                ),
                color: const Color(0xFF608AAE),
              ),
              child: ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesión'),
                onTap: () {
                  Provider.of<UserProvider>(context, listen: false).clearUser();
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
