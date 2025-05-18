// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stopnow/data/models/user_model.dart';

final frasesMotivadoras = [
  "¡Felicidades! Has dejado de fumar.",
  "Cada día es una victoria.",
  "Tu salud es lo más importante.",
  "Eres más fuerte de lo que piensas.",
  "Cada día sin fumar es un logro.",
  "La vida es mejor sin tabaco.",
  "Celebra tus logros, por pequeños que sean.",
  "Tu esfuerzo vale la pena.",
  "Cada día es una nueva oportunidad.",
  "Sigue adelante, estás haciendo un gran trabajo.",
  "Cada respiro sin humo es una victoria.",
  "Hoy es un buen día para seguir ganando.",
  "Lo difícil ya empezó. Lo valiente eres tú.",
  "Un día más fuerte, un cigarro menos.",
  "Esto no es fácil, pero tampoco imposible.",
  "Estás más lejos del primer cigarro, y más cerca de tu meta.",
  "Menos humo, más vida.",
  "No necesitas uno. Ya lo sabes.",
  "Tu yo de mañana te está aplaudiendo.",
  "No estás empezando de cero. Estás empezando desde la experiencia.",
  "Cada minuto limpio suma. Cada minuto cuenta.",
  "Tú mandas. No el impulso.",
  "Estás cambiando tu historia, un día a la vez.",
  "Cada día sin fumar es un paso hacia una vida más saludable.",
  "Tu esfuerzo hoy es tu recompensa mañana.",
  "La vida es mejor sin humo.",
  "Cada día es una nueva oportunidad para ser más fuerte.",
  "Eres un guerrero, sigue luchando.",
  "Cada respiro limpio es un regalo para ti mismo.",
  "Tu salud es tu mayor tesoro, cuídala.",
  "Cada día sin fumar es un paso hacia una vida más plena.",
  "Eres capaz de lograrlo, no te rindas.",
];

class HomeProvider with ChangeNotifier {
  final UserModel? user;
  Timer? _timer;
  late final String _fraseDelDia;

  HomeProvider(this.user) {
    _fraseDelDia = frasesMotivadoras[Random().nextInt(frasesMotivadoras.length)];
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

   String getFrase() => _fraseDelDia;

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

  int getDineroAhorrado() {
    if (user == null) return 0;

    double precioPorCigarro = user!.precioPaquete / user!.cigarrosPorPaquete;

    return (getCigarrosEvitados() * precioPorCigarro).round();
  }

  int getCigarrosEvitados() {
    if (user == null) return 0;

    DateTime start = user!.fechaDejarFumar;
    DateTime now = DateTime.now();

    int diff = now.difference(start).inDays;

    return diff * user!.cigarrosAlDia;
  }

  int getTiempoDeVidaGanado() {
    if (user == null) return 0;
    return getCigarrosEvitados() * 11;
  }

  int getDiasSinFumar() {
    if (user == null) return 0;
    DateTime start = user!.fechaDejarFumar;
    DateTime now = DateTime.now();
    return now.difference(start).inDays;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
