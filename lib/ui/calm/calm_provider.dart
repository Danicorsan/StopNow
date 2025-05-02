import 'package:flutter/material.dart';
import 'dart:async';

class CalmProvider extends ChangeNotifier {
  bool init = false;
  late Timer _timer;
  int _timeRemaining = 1; // Tiempo restante para cada fase
  String _currentPhase = "Inhalar"; // Estado actual de la fase
  String? _image;
  String get currentPhase => _currentPhase;
  int get timeRemaining => _timeRemaining;
  String get image => _image ?? "assets/inhala.png";

  void iniciar() {
    init = true;
    _timeRemaining = 4; // Comenzamos con la fase de inhalar
    _currentPhase = "Inhalar";
    _iniciarTiempo();
    notifyListeners();
  }

  void _iniciarTiempo() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 1) {
        _timeRemaining--;
        notifyListeners();
      } else {
        _changePhase();
      }
    });
  }

  void _changePhase() {
    // Cambia la fase y reinicia el tiempo para la nueva fase
    if (_currentPhase == "Inhalar") {
      _currentPhase = "Retener";
      _timeRemaining = 7;
      _image = "assets/aguanta.png";
    } else if (_currentPhase == "Retener") {
      _currentPhase = "Exhalar";
      _timeRemaining = 8;
      _image = "assets/exhala.png";
    } else if (_currentPhase == "Exhalar") {
      _currentPhase = "Inhalar";
      _timeRemaining = 4;
      _image = "assets/inhala.png";
    }
    notifyListeners(); // Actualiza la UI con el cambio de fase
  }

  void reset() {
    _timer.cancel();
    init = false;
    _timeRemaining = 1;
    _currentPhase = "Inhalar";
    _image = "assets/inhala.png";
    notifyListeners();
  }
}
