import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserStatus(bool hasAccount) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasAccount', hasAccount);
}