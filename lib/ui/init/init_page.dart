// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopnow/data/dao/user_dao.dart';
import 'package:stopnow/data/helper/local_database_helper.dart';
import 'package:stopnow/data/models/user_model.dart';
import 'package:stopnow/data/providers/user_provider.dart';
import 'package:stopnow/routes/app_routes.dart';
import 'package:stopnow/ui/login/login_provider.dart';
import 'package:stopnow/ui/login/login_state.dart';
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
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        return;
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
        return;
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final hasAccount = prefs.getBool('hasAccount') ?? false;

    if (hasAccount) {
      final email = prefs.getString('email');
      final password = prefs.getString('password');

      if (email != null && password != null) {
        Provider.of<LoginProvider>(context, listen: false).correo = email;
        Provider.of<LoginProvider>(context, listen: false).contrasenia =
            password;

        await Provider.of<LoginProvider>(context, listen: false).login(context);

        if (Provider.of<LoginProvider>(context, listen: false).loginState ==
            LoginState.success) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
          return;
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.welcome);
          return;
        }
      }
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF608AAE),
        ),
      ),
    );
  }
}
