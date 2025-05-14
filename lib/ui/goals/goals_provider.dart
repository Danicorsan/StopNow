import 'package:flutter/material.dart';
import 'package:stopnow/data/models/goal_model.dart';

class GoalsProvider extends ChangeNotifier {
  final List<GoalModel> _goals = [];

  List<GoalModel> get goals => List.unmodifiable(_goals);

  void addGoal(GoalModel goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void removeGoal(int index) {
    _goals.removeAt(index);
    notifyListeners();
  }
}