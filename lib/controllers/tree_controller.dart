import 'package:flutter/material.dart';
import '../models/tree_model.dart';

class ReminderModel {
  final String id;
  final String treeId;
  final String treeName;
  final String type;
  final String message;
  final DateTime dueDate;

  ReminderModel({
    required this.id,
    required this.treeId,
    required this.treeName,
    required this.type,
    required this.message,
    required this.dueDate,
  });
}

class TreeController extends ChangeNotifier {
  List<TreeModel> _trees = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TreeModel> get trees => _trees;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get healthyTreesCount {
    return _trees.where((tree) => tree.healthStatus == 'Healthy').length;
  }

  int get needsWateringCount {
    return _trees.where((tree) => tree.needsWatering).length;
  }

  List<ReminderModel> get todayReminders {
    List<ReminderModel> reminders = [];
    for (var tree in _trees) {
      if (tree.needsWatering) {
        reminders.add(ReminderModel(
          id: '${tree.id}_water',
          treeId: tree.id,
          treeName: tree.name,
          type: 'Watering',
          message: '${tree.name} needs watering',
          dueDate: DateTime.now(),
        ));
      }
    }
    return reminders;
  }

  Future<void> loadTrees() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _trees = [
      TreeModel(
        id: '1',
        name: 'Oak Tree',
        species: 'Quercus robur',
        location: 'Front Yard',
        plantedDate: DateTime(2022, 3, 15),
        healthStatus: 'Healthy',
        lastWatered: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TreeModel(
        id: '2',
        name: 'Apple Tree',
        species: 'Malus domestica',
        location: 'Backyard',
        plantedDate: DateTime(2021, 5, 20),
        healthStatus: 'Healthy',
        lastWatered: DateTime.now().subtract(const Duration(days: 5)),
      ),
      TreeModel(
        id: '3',
        name: 'Cherry Blossom',
        species: 'Prunus serrulata',
        location: 'Garden',
        plantedDate: DateTime(2023, 1, 10),
        healthStatus: 'Needs Attention',
        lastWatered: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void addTree(TreeModel tree) {
    _trees.add(tree);
    notifyListeners();
  }

  void updateTree(TreeModel updatedTree) {
    final index = _trees.indexWhere((tree) => tree.id == updatedTree.id);
    if (index != -1) {
      _trees[index] = updatedTree;
      notifyListeners();
    }
  }

  void deleteTree(String treeId) {
    _trees.removeWhere((tree) => tree.id == treeId);
    notifyListeners();
  }

  void waterTree(String treeId) {
    final index = _trees.indexWhere((tree) => tree.id == treeId);
    if (index != -1) {
      _trees[index] = _trees[index].copyWith(lastWatered: DateTime.now());
      notifyListeners();
    }
  }
}