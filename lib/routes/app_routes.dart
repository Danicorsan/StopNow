import 'package:flutter/material.dart';
import 'package:stopnow/ui/home/home_page.dart';
import 'package:stopnow/ui/login/login_page.dart';
import 'package:stopnow/ui/register/register_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = "/register";

  static final Map<String, WidgetBuilder> routes = {
    home: (_) => HomePage(),
    login: (_) => LoginPage(),
    register: (_) => RegisterPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    } else {
      return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Placeholder())));
    }
  }
}
