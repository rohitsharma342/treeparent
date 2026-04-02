import 'care_log_model.dart';

enum TreeHealthStatus { excellent, good, needsAttention, critical }

class TreeModel {
  final String id;
  final String name;
  final String species;
  final DateTime plantedDate;
  final String location;
  final TreeHealthStatus healthStatus;
  final String imageUrl;
  final String notes;
  final List<CareLogModel> careLogs;
  final DateTime? lastWatered;
  final DateTime? lastFertilized;
  final DateTime? lastPruned;

  TreeModel({
    required this.id,
    required this.name,
    required this.species,
    required this.plantedDate,
    required this.location,
    this.healthStatus = TreeHealthStatus.good,
    required this.imageUrl,
    this.notes = '',
    this.careLogs = const [],
    this.lastWatered,
    this.lastFertilized,
    this.lastPruned,
  });

  int get ageInDays => DateTime.now().difference(plantedDate).inDays;

  String get ageDisplay {
    final days = ageInDays;
    if (days < 30) return '$days days';
    if (days < 365) return '${(days / 30).floor()} months';
    return '${(days / 365).floor()} years';
  }

  TreeModel copyWith({
    String? id,
    String? name,
    String? species,
    DateTime? plantedDate,
    String? location,
    TreeHealthStatus? healthStatus,
    String? imageUrl,
    String? notes,
    List<CareLogModel>? careLogs,
    DateTime? lastWatered,
    DateTime? lastFertilized,
    DateTime? lastPruned,
  }) {
    return TreeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      plantedDate: plantedDate ?? this.plantedDate,
      location: location ?? this.location,
      healthStatus: healthStatus ?? this.healthStatus,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      careLogs: careLogs ?? this.careLogs,
      lastWatered: lastWatered ?? this.lastWatered,
      lastFertilized: lastFertilized ?? this.lastFertilized,
      lastPruned: lastPruned ?? this.lastPruned,
    );
  }
}