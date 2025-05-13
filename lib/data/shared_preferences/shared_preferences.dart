import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserStatus(
    bool hasAccount, String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasAccount', hasAccount);
  await prefs.setString('email', email);
  await prefs.setString('password', password);
}
