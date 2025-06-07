import 'package:flutter/material.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/repositories/user_repository.dart';

class GoalsProvider extends ChangeNotifier {
  final List<GoalModel> _goals = [];

  List<GoalModel> get goals => List.unmodifiable(_goals);
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> traerObjetivos() async {
    _isLoading = true;
    final result = await UserRepository.obtenerObjetivos();

    if (result is BaseResultSuccess) {
      _goals.clear();
      final dataList = result.data as List<dynamic>;
      _goals.addAll(
          dataList.map((e) => GoalModel.fromJson(e as Map<String, dynamic>)));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addGoal(GoalModel goal, BuildContext context) async {
    BaseResult exito = await UserRepository.subirObjetivo(goal);

    if (exito is BaseResultError) {
      return false;
    }
    _goals.add(goal);
    notifyListeners();
    return true;
  }

  Future<bool> removeGoal(String id) async {
    var exito = await UserRepository.borrarObjetivo(id);

    if (exito is BaseResultError) {
      return false;
    } else if (exito is BaseResultSuccess) {
      _goals.removeAt(_goals.indexWhere((element) => element.id == id));
      await traerObjetivos();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editGoal({
    required GoalModel originalGoal,
    required String nombreNuevo,
    required String descripcionNueva,
    required double precioNuevo,
    required BuildContext context,
  }) async {
    final exito = await UserRepository.actualizarObjetivo(
      id: originalGoal.id,
      nombreNuevo: nombreNuevo,
      descripcionNueva: descripcionNueva,
      precioNuevo: precioNuevo,
    );

    if (exito is BaseResultSuccess) {
      await traerObjetivos();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
