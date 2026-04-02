enum CareActivityType { watering, fertilizing, pruning, repotting, pestControl, other }

class CareLogModel {
  final String id;
  final String treeId;
  final CareActivityType activityType;
  final DateTime activityDate;
  final String notes;
  final DateTime createdAt;

  CareLogModel({
    required this.id,
    required this.treeId,
    required this.activityType,
    required this.activityDate,
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get activityTypeDisplay {
    switch (activityType) {
      case CareActivityType.watering:
        return 'Watering';
      case CareActivityType.fertilizing:
        return 'Fertilizing';
      case CareActivityType.pruning:
        return 'Pruning';
      case CareActivityType.repotting:
        return 'Repotting';
      case CareActivityType.pestControl:
        return 'Pest Control';
      case CareActivityType.other:
        return 'Other';
    }
  }

  CareLogModel copyWith({
    String? id,
    String? treeId,
    CareActivityType? activityType,
    DateTime? activityDate,
    String? notes,
    DateTime? createdAt,
  }) {
    return CareLogModel(
      id: id ?? this.id,
      treeId: treeId ?? this.treeId,
      activityType: activityType ?? this.activityType,
      activityDate: activityDate ?? this.activityDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}