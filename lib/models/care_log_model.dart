class CareLogModel {
  final String id;
  final String treeId;
  final String careType;
  final String? notes;
  final DateTime date;

  CareLogModel({
    required this.id,
    required this.treeId,
    required this.careType,
    this.notes,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'treeId': treeId,
      'careType': careType,
      'notes': notes,
      'date': date.toIso8601String(),
    };
  }

  factory CareLogModel.fromJson(Map<String, dynamic> json) {
    return CareLogModel(
      id: json['id'] as String,
      treeId: json['treeId'] as String,
      careType: json['careType'] as String,
      notes: json['notes'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }
}