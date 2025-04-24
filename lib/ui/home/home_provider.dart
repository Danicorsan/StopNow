import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stopnow/data/models/user.dart';

class HomeProvider with ChangeNotifier {
  final UserModel? user;
  Timer? _timer;

  HomeProvider(this.user) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Por si se reinicializa
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      notifyListeners(); // Hace que se reconstruya la UI
    });
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  int getAnios() {
    if (user == null) return 0;
    DateTime now = DateTime.now();
    DateTime start = user!.fechaDejarFumar;

    int years = now.year - start.year;
    if (now.month < start.month ||
        (now.month == start.month && now.day < start.day)) {
      years--;
    }

    return years;
  }

  int getMeses() {
    if (user == null) return 0;
    DateTime now = DateTime.now();
    DateTime start = user!.fechaDejarFumar;

    int months = now.month - start.month;
    if (now.day < start.day) {
      months--;
    }
    if (months < 0) {
      months += 12;
    }

    return months;
  }

  int getDias() {
    if (user == null) return 0;
    DateTime now = DateTime.now();
    DateTime start = user!.fechaDejarFumar;

    DateTime thisMonthStart = DateTime(now.year, now.month, now.day);
    DateTime lastMonthStart =
        DateTime(thisMonthStart.year, thisMonthStart.month - 1, start.day);

    Duration duration =
        now.difference(DateTime(now.year, now.month, start.day));
    int days = duration.inDays;
    if (days < 0) {
      final prevMonth =
          DateTime(now.year, now.month, 0); // último día del mes anterior
      days += prevMonth.day;
    }

    return days;
  }

  int getHoras() {
    if (user == null) return 0;
    DateTime start = user!.fechaDejarFumar;
    DateTime now = DateTime.now();
    Duration diff = now.difference(start);

    return diff.inHours % 24;
  }

  int getMinutos() {
    if (user == null) return 0;
    DateTime start = user!.fechaDejarFumar;
    DateTime now = DateTime.now();
    Duration diff = now.difference(start);

    return diff.inMinutes % 60;
  }

  int getSegundos() {
    if (user == null) return 0;
    DateTime start = user!.fechaDejarFumar;
    DateTime now = DateTime.now();
    Duration diff = now.difference(start);

    return diff.inSeconds % 60;
  }
}
