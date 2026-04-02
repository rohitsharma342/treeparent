import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/tree_model.dart';
import '../models/care_log_model.dart';
import '../data/static_data.dart';

class TreeController extends ChangeNotifier {
  List<TreeModel> _trees = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<TreeModel> get trees => _searchQuery.isEmpty
      ? _trees
      : _trees.where((tree) =>
          tree.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tree.species.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<ReminderItem> get reminders {
    final List<ReminderItem> items = [];
    final now = DateTime.now();

    for (final tree in _trees) {
      if (tree.lastWatered == null || now.difference(tree.lastWatered!).inDays >= 3) {
        items.add(ReminderItem(
          treeId: tree.id,
          treeName: tree.name,
          type: 'Water',
          dueDate: tree.lastWatered?.add(const Duration(days: 3)) ?? now,
          isOverdue: tree.lastWatered == null || now.difference(tree.lastWatered!).inDays > 3,
        ));
      }

      if (tree.lastFertilized == null || now.difference(tree.lastFertilized!).inDays >= 30) {
        items.add(ReminderItem(
          treeId: tree.id,
          treeName: tree.name,
          type: 'Fertilize',
          dueDate: tree.lastFertilized?.add(const Duration(days: 30)) ?? now,
          isOverdue: tree.lastFertilized == null || now.difference(tree.lastFertilized!).inDays > 30,
        ));
      }
    }

    items.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return items;
  }

  Future<void> loadTrees() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _trees = StaticData.sampleTrees;

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  TreeModel? getTreeById(String id) {
    try {
      return _trees.firstWhere((tree) => tree.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addTree(TreeModel tree) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final newTree = TreeModel(
      id: const Uuid().v4(),
      name: tree.name,
      species: tree.species,
      plantedDate: tree.plantedDate,
      location: tree.location,
      healthStatus: tree.healthStatus,
      imageUrl: tree.imageUrl,
      notes: tree.notes,
      careLogs: [],
      lastWatered: DateTime.now(),
      lastFertilized: DateTime.now(),
    );

    _trees.add(newTree);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> updateTree(TreeModel updatedTree) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final index = _trees.indexWhere((tree) => tree.id == updatedTree.id);
    if (index != -1) {
      _trees[index] = updatedTree;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage = 'Tree not found';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> deleteTree(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _trees.removeWhere((tree) => tree.id == id);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> addCareLog(String treeId, CareLogModel careLog) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final index = _trees.indexWhere((tree) => tree.id == treeId);
    if (index != -1) {
      final tree = _trees[index];
      final newCareLog = CareLogModel(
        id: const Uuid().v4(),
        treeId: treeId,
        activityType: careLog.activityType,
        activityDate: careLog.activityDate,
        notes: careLog.notes,
      );

      final updatedCareLogs = [...tree.careLogs, newCareLog];
      
      DateTime? lastWatered = tree.lastWatered;
      DateTime? lastFertilized = tree.lastFertilized;
      DateTime? lastPruned = tree.lastPruned;

      switch (careLog.activityType) {
        case CareActivityType.watering:
          lastWatered = careLog.activityDate;
          break;
        case CareActivityType.fertilizing:
          lastFertilized = careLog.activityDate;
          break;
        case CareActivityType.pruning:
          lastPruned = careLog.activityDate;
          break;
        default:
          break;
      }

      _trees[index] = tree.copyWith(
        careLogs: updatedCareLogs,
        lastWatered: lastWatered,
        lastFertilized: lastFertilized,
        lastPruned: lastPruned,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage = 'Tree not found';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

class ReminderItem {
  final String treeId;
  final String treeName;
  final String type;
  final DateTime dueDate;
  final bool isOverdue;

  ReminderItem({
    required this.treeId,
    required this.treeName,
    required this.type,
    required this.dueDate,
    this.isOverdue = false,
  });
}