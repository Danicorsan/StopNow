import 'package:flutter/material.dart';
import 'package:stopnow/data/models/user.dart';

class HomeProvider with ChangeNotifier {
  final UserModel? user;

  HomeProvider(this.user);

  // Calcula los días y horas desde que el usuario dejó de fumar
  String getDaysAndHours() {
    if (user != null) {
      final fechaDeJardeFumar = user!.fechaDejarFumar;
      final currentDate = DateTime.now();
      final difference = currentDate.difference(fechaDeJardeFumar!);
      int days = difference.inDays;
      int hours = difference.inHours % 24;
      return "$days días y $hours horas";
    }
    return "Fecha no disponible";
  }
}
