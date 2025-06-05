import 'package:flutter/material.dart';
import 'dart:async';

enum CalmPhase { inhalar, retener, exhalar }

class CalmProvider extends ChangeNotifier {
  bool init = false;
  late Timer _timer;
  int _timeRemaining = 1;
  CalmPhase _currentPhase = CalmPhase.inhalar;
  String? _image;
  CalmPhase get currentPhase => _currentPhase;
  int get timeRemaining => _timeRemaining;
  String get image => _image ?? "assets/inhala.png";

  void iniciar() {
    init = true;
    _timeRemaining = 4; // Comenzamos con la fase de inhalar
    _currentPhase = CalmPhase.inhalar;
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
    if (_currentPhase == CalmPhase.inhalar) {
      _currentPhase = CalmPhase.retener;
      _timeRemaining = 7;
      _image = "assets/aguanta.png";
    } else if (_currentPhase == CalmPhase.retener) {
      _currentPhase = CalmPhase.exhalar;
      _timeRemaining = 8;
      _image = "assets/exhala.png";
    } else if (_currentPhase == CalmPhase.exhalar) {
      _currentPhase = CalmPhase.inhalar;
      _timeRemaining = 4;
      _image = "assets/inhala.png";
    }
    notifyListeners();
  }

  void reset() {

    _timer.cancel();
    init = false;
    _timeRemaining = 1;
    _currentPhase = CalmPhase.inhalar;
    _image = "assets/inhala.png";
    notifyListeners();
  }
}
