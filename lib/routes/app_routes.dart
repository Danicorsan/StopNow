import 'package:flutter/material.dart';
import 'package:stopnow/ui/calm/calm.dart';
import 'package:stopnow/ui/goals/add/add_goals.dart';
import 'package:stopnow/ui/goals/home/goals_page.dart';
import 'package:stopnow/ui/home/home_page.dart';
import 'package:stopnow/ui/login/login_page.dart';
import 'package:stopnow/ui/profile/profile_page.dart';
import 'package:stopnow/ui/register/register_page.dart';
import 'package:stopnow/ui/welcome/welcome_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String welcome = '/welcome';
  static const String profile = '/profile';
  static const String calma = '/calma';
  static const String goals = '/goals';
  static const String addGoal = '/addGoal';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case login:
        // Cogemos los argumentos de la ruta
        final args = settings.arguments as Map<String, String>?;

        return MaterialPageRoute(
          builder: (_) => LoginPage(
            email: args?['email'],
            password: args?['password'],
          ),
        );

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case calma:
        return MaterialPageRoute(builder: (_) => const CalmPage());

      case goals:
        return MaterialPageRoute(builder: (_) => const GoalsPage());

      case addGoal:
        return MaterialPageRoute(builder: (_) => const AddGoalsPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Página no encontrada')),
          ),
        );
    }
  }
}
