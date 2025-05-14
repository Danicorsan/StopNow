import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasAccount', false);
    await prefs.remove('email');
    await prefs.remove('password');

    Provider.of<UserProvider>(context, listen: false).clearUser();

    // Redirige al usuario a la página de bienvenida
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.welcome,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: baseAppBar("Ajustes"),
      drawer: baseDrawer(context),
      body: Container(
        width: double.infinity,
        /*
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF153866), Color(0xFF608AAE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          )*/
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          children: [
            _buildSettingsCard(
              icon: Icons.account_circle,
              title: 'Cuenta',
              subtitle: 'Gestiona tu información personal',
              color: Colors.blueAccent,
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.settingsAcount);
              },
            ),
            _buildSettingsCard(
              icon: Icons.replay,
              title: 'Recaída',
              subtitle: '¿Tuviste una recaída? Reinicia tu progreso',
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.settingsAcount);
              },
            ),
            _buildSettingsCard(
              icon: Icons.logout,
              title: 'Cerrar sesión',
              subtitle: 'Salir de tu cuenta',
              color: Colors.redAccent,
              onTap: () {
                Provider.of<UserProvider>(context, listen: false).clearUser();
                logout();
              },
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "StopNow v0.1.0",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF153866),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 13,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            color: Color(0xFF153866)),
        onTap: onTap,
      ),
    );
  }
}
