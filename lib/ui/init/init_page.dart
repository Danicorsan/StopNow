// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopnow/data/helper/local_database_helper.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity.first == ConnectivityResult.none) {
      // Sin internet: carga usuario offline de SQLite
      final offlineUser = await LocalDbHelper.getUserProgress();
      if (offlineUser != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(offlineUser);
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, (route) => false);
        return;
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.welcome, (route) => false);
        return;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final hasAccount = prefs.getBool('hasAccount') ?? false;

    await Future.delayed(const Duration(seconds: 2));

    if (hasAccount) {
      // Si hay cuenta, carga usuario desde SQLite
      final offlineUser = await LocalDbHelper.getUserProgress();
      if (offlineUser != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(offlineUser);
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home,(route) => false);
        return;
      } else {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome,(route) => false);
        return;
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome,(route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: colorScheme.primary,
          rightDotColor: colorScheme.secondary,
          size: 50,
        ),
      ),
    );
  }
}
