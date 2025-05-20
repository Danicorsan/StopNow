import 'package:flutter/material.dart';
import 'package:stopnow/data/models/goal_model.dart';
import 'package:stopnow/data/network/base_result.dart';
import 'package:stopnow/data/repositories/user_repository.dart';
import 'package:stopnow/ui/base/widgets/base_error.dart';

class GoalsProvider extends ChangeNotifier {
  final List<GoalModel> _goals = [];

  List<GoalModel> get goals => List.unmodifiable(_goals);
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> traerObjetivos() async {
    _isLoading = true;
    await Future.delayed(const Duration(seconds: 2));
    final result = await UserRepository.obtenerObjetivos();

    if (result is BaseResultSuccess) {
      _goals.clear();
      final dataList = result.data as List<dynamic>;
      _goals.addAll(
          dataList.map((e) => GoalModel.fromJson(e as Map<String, dynamic>)));
    }
    // Si quieres manejar errores, puedes hacerlo aquí con un else
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addGoal(GoalModel goal, BuildContext context) async {
    bool exito = await UserRepository.subirObjetivo(goal);

    if (!exito) {
      return false;
    }
    _goals.add(goal);
    notifyListeners();
    return true;
  }

  void removeGoal(int index, BuildContext context) async {
    await UserRepository.borrarObjetivo(_goals[index]);

    _goals.removeAt(index);

    await traerObjetivos();

    notifyListeners();
    buildSuccesMessage("Objetivo borrado con exito", context);
  }
}
