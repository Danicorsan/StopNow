import 'package:flutter/material.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/ui/achievement/achievement_page.dart';
import 'package:stopnow/ui/calm/calm_page.dart';
import 'package:stopnow/ui/goals/add_goals.dart';
import 'package:stopnow/ui/goals/detail_goals.dart';
import 'package:stopnow/ui/goals/goals_page.dart';
import 'package:stopnow/ui/home/home_page.dart';
import 'package:stopnow/ui/init/init_page.dart';
import 'package:stopnow/ui/login/login_page.dart';
import 'package:stopnow/ui/messages/message_page.dart';
import 'package:stopnow/ui/profile/profile_page.dart';
import 'package:stopnow/ui/register/register_page.dart';
import 'package:stopnow/ui/settings/account/account_page.dart';
import 'package:stopnow/ui/settings/settings_page.dart';
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
  static const String settingsPage = '/settings';
  static const String settingsAcount = '/settings/account';
  static const String init = '/init';
  static const String detailGoal = '/detailGoal';
  static const String chat = '/chat';
  static const String achievement = '/achievement';

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

      case settingsPage:
        return MaterialPageRoute(builder: (_) => const SettingsPage());

      case settingsAcount:
        return MaterialPageRoute(builder: (_) => const SettingsAccountPage());

      case init:
        return MaterialPageRoute(builder: (_) => const InitPage());

      case detailGoal:
        final goal = settings.arguments as GoalModel;
        return MaterialPageRoute(
          builder: (_) => DetailGoalsPage(goal: goal),
        );

      case chat:
        return MaterialPageRoute(builder: (_) => const ChatPage());

      case achievement:
        return MaterialPageRoute(
          builder: (_) => const AchievementsPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Página no encontrada')),
          ),
        );
    }
  }
}
