import 'package:flutter/material.dart';
import 'package:stopnow/ui/home/home_page.dart';
import 'package:stopnow/ui/login/login_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';

  static final Map<String, WidgetBuilder> routes = {
    home: (_) => const HomePage(),
    login: (_) => const LoginPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    } else {
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Ha habido un problema')),
        ),
      );
    }
  }
}
