// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopnow/data/helper/local_database_helper.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/data/providers/theme_provider.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/base/widgets/base_appbar.dart';
import 'package:stopnow/ui/base/widgets/base_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Elimina los datos del usuario
    await prefs.setBool('hasAccount', false);
    await prefs.remove('email');
    await prefs.remove('password');
    await LocalDbHelper.deleteUserProgress();

    // Elimina el usuario del UserProvider y restablece el tema
    Provider.of<UserProvider>(context, listen: false).clearUser();
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(false);

    // Elimina las notificaciones programadas
    await UserRepository.cancelAllNotifications();

    // Navega a la pantalla de bienvenida y elimina todas las rutas anteriores
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.welcome,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: baseAppBar(localizations.ajustes),
      drawer: baseDrawer(context),
      backgroundColor: colorScheme.background,
      body: SizedBox(
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          children: [
            _buildSettingsCard(
              icon: Icons.account_circle,
              title: localizations.cuenta,
              subtitle: localizations.gestionaInformacion,
              color: colorScheme.secondary,
              onTap: () async {
                final conexion = await UserRepository.tienesConexion();
                if (!conexion) {
                  buildErrorMessage(localizations.sinConexion, context);
                  return;
                }
                Navigator.pushNamed(context, AppRoutes.settingsAcount);
              },
              colorScheme: colorScheme,
            ),
            _buildSettingsCard(
              icon: Icons.replay,
              title: localizations.recaida,
              subtitle: localizations.mensajeRecaida,
              color: colorScheme.secondary,
              onTap: () async {
                final conexion = await UserRepository.tienesConexion();
                if (!conexion) {
                  buildErrorMessage(localizations.sinConexion, context);
                  return;
                }

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: colorScheme.surface,
                    title: Text(
                      localizations.recaida,
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    content: Text(
                      localizations.dialogoRecaida,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          localizations.cancelar, // O "Cancelar"
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                        ),
                        onPressed: () async {
                          AppLocalizations localizations =
                              AppLocalizations.of(context)!;
                          var result = await UserRepository.reiniciarFechaFumar(
                              localizations);

                          if (result is BaseResultError) {
                            return;
                          }

                          // Recarga el usuario actualizado y actualiza el provider
                          final user = await UserRepository.usuarioActual();
                          if (user != null) {
                            Provider.of<UserProvider>(context, listen: false)
                                .setUser(user);
                          }

                          Navigator.pushNamedAndRemoveUntil(
                              context, AppRoutes.home, (route) => false);
                        },
                        child: Text(localizations.aceptar),
                      ),
                    ],
                  ),
                );
              },
              colorScheme: colorScheme,
            ),
            _buildSettingsCard(
              icon: Icons.notifications,
              title:
                  localizations.gestionarPermisos, // Añade esta clave a tu l10n
              subtitle: localizations
                  .gestionarPermisosDesc, // Añade esta clave a tu l10n
              color: colorScheme.secondary,
              onTap: () async {
                await openAppSettings();
              },
              colorScheme: colorScheme,
            ),
            _buildThemeSwitchCard(context, localizations, colorScheme),
            _buildSettingsCard(
              icon: Icons.info_outline,
              title: localizations.acercaDe,
              subtitle: localizations.informacionSobreStopnow,
              color: colorScheme.secondary,
              onTap: () async {
                Navigator.pushNamed(context, AppRoutes.about);
              },
              colorScheme: colorScheme,
            ),
            _buildSettingsCard(
              icon: Icons.logout,
              title: localizations.cerrarSesion,
              subtitle: localizations.salirCuenta,
              color: colorScheme.secondary,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: colorScheme.surface,
                    title: Text(
                      localizations.confirmarCerrarSesion,
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    content: Text(
                      localizations.mensajeConfirmarCerrarSesion,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          localizations.cancelar,
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                        ),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => Center(
                              child: LoadingAnimationWidget.flickr(
                                leftDotColor: colorScheme.primary,
                                rightDotColor: colorScheme.secondary,
                                size: 50,
                              ),
                            ),
                          );

                          Provider.of<UserProvider>(context, listen: false)
                              .clearUser();
                          logout();
                        },
                        child: Text(localizations.aceptar),
                      ),
                    ],
                  ),
                );
              },
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "StopNow v1.0.0",
                style: TextStyle(
                  color: colorScheme.onBackground.withOpacity(0.7),
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
    required ColorScheme colorScheme,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: colorScheme.surface,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: colorScheme.primary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 13,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

Widget _buildThemeSwitchCard(BuildContext context,
    AppLocalizations localizations, ColorScheme colorScheme) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final isDark = themeProvider.themeMode == ThemeMode.dark;
  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    margin: const EdgeInsets.symmetric(vertical: 12),
    color: colorScheme.surface,
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.secondary.withOpacity(0.15),
        child: Icon(Icons.brightness_6, color: colorScheme.secondary, size: 28),
      ),
      title: Text(
        localizations.temaOscuro,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: colorScheme.primary,
        ),
      ),
      subtitle: Text(
        localizations.cambiaElTema,
        style: TextStyle(
          color: colorScheme.onSurface.withOpacity(0.7),
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: isDark,
        onChanged: (value) {
          themeProvider.toggleTheme(value);
        },
        activeColor: colorScheme.secondary,
        inactiveThumbColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.primary.withOpacity(0.1),
      ),
      onTap: () {
        themeProvider.toggleTheme(!isDark);
      },
    ),
  );
}
