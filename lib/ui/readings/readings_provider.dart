import 'package:flutter/material.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/data/models/reading_model.dart';

class ReadingsProvider extends ChangeNotifier {
  List<ReadingModel> _articulos = [];
  bool isLoading = true;

  List<ReadingModel> get articulos => List.unmodifiable(_articulos);

  Future<void> cargarArticulos(/*Locale locale*/) async {
    try {
      isLoading = true;
      notifyListeners();
      _articulos = await UserRepository.traerArticulos();
    } catch (e) {
      print('Error al cargar artículos: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
