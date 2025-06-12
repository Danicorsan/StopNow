import 'package:shared_preferences/shared_preferences.dart';

/// Guarda el estado del usuario (si tiene cuenta o no) en SharedPreferences.
Future<void> saveUserStatus(
    bool hasAccount) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasAccount', hasAccount);
}
