import 'package:flutter/material.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/data/models/reading_model.dart';

class ReadingsProvider extends ChangeNotifier {
  List<ReadingModel> _articulos = [];
  bool isLoading = true;

  List<ReadingModel> get articulos => List.unmodifiable(_articulos);

  Future<void> cargarArticulos(/*Locale locale*/) async {
    isLoading = true;
    notifyListeners();

    var result = await UserRepository.traerArticulos();

    if (result is BaseResultSuccess) {
      isLoading = false;

      _articulos = result.data;

      notifyListeners();
      return;
    }

    isLoading = false;
    notifyListeners();
  }
}
