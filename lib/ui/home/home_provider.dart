import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stopnow/data/models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<String> getFrasesMotivadoras(AppLocalizations loc) => [
      loc.frasebienvenida1,
      loc.frasebienvenida2,
      loc.frasebienvenida3,
      loc.frasebienvenida4,
      loc.frasebienvenida5,
      loc.frasebienvenida6,
      loc.frasebienvenida7,
      loc.frasebienvenida8,
      loc.frasebienvenida9,
      loc.frasebienvenida10,
      loc.frasebienvenida11,
      loc.frasebienvenida12,
      loc.frasebienvenida13,
      loc.frasebienvenida14,
      loc.frasebienvenida15,
      loc.frasebienvenida16,
      loc.frasebienvenida17,
      loc.frasebienvenida18,
      loc.frasebienvenida19,
      loc.frasebienvenida20,
      loc.frasebienvenida21,
      loc.frasebienvenida22,
      loc.frasebienvenida23,
      loc.frasebienvenida24,
      loc.frasebienvenida25,
      loc.frasebienvenida26,
      loc.frasebienvenida27,
      loc.frasebienvenida28,
      loc.frasebienvenida29,
      loc.frasebienvenida30,
      loc.frasebienvenida31,
      loc.frasebienvenida32,
    ];

class HomeProvider with ChangeNotifier {
  final UserModel? user;
  Timer? _timer;
  late final String _fraseDelDia;

  HomeProvider(this.user, AppLocalizations loc) {
    final frases = getFrasesMotivadoras(loc);
    _fraseDelDia = frases[Random().nextInt(frases.length)];
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
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

    // Calcular años y meses completos
    // ignore: unused_local_variable
    int years = now.year - start.year;
    int months = now.month - start.month;
    int days = now.day - start.day;

    if (days < 0) {
      // Restar un mes y sumar los días del mes anterior
      months--;
      // Calcular días en el mes anterior a 'now'
      DateTime prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years--;
      months += 12;
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

  /// Cambia los cálculos a minutos para mostrar progreso desde el primer minuto

  double getCigarrosEvitados() {
    if (user == null) return 0;
    DateTime start = user!.fechaDejarFumar;
    DateTime now = DateTime.now();
    int minutos = now.difference(start).inMinutes;
    // Cigarros evitados por minuto
    double cigarrosPorMinuto = user!.cigarrosAlDia / 1440.0;
    return (minutos * cigarrosPorMinuto);
  }

  double getDineroAhorrado() {
    if (user == null) return 0;
    double precioPorCigarro = user!.precioPaquete / user!.cigarrosPorPaquete;
    return (getCigarrosEvitados() * precioPorCigarro);
  }

  double getTiempoDeVidaGanado() {
    if (user == null) return 0;
    return getCigarrosEvitados() * 11;
  }

  int getDiasSinFumar() {
    if (user == null) return 0;
    DateTime start = user!.fechaDejarFumar;
    DateTime now = DateTime.now();
    return now.difference(start).inDays;
  }

  int getHorasSinFumar() {
    if (user == null) return 0;
    DateTime start = user!.fechaDejarFumar;
    DateTime now = DateTime.now();
    return now.difference(start).inHours;
  }

  int getMinutosSinFumar() {
    if (user == null) return 0;
    DateTime start = user!.fechaDejarFumar;
    DateTime now = DateTime.now();
    return now.difference(start).inMinutes;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
