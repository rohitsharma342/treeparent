class TreeModel {
  final String id;
  final String name;
  final String species;
  final String location;
  final DateTime plantedDate;
  final String healthStatus;
  final String? imageUrl;
  final DateTime? lastWatered;
  final DateTime? lastFertilized;

  TreeModel({
    required this.id,
    required this.name,
    required this.species,
    required this.location,
    required this.plantedDate,
    required this.healthStatus,
    this.imageUrl,
    this.lastWatered,
    this.lastFertilized,
  });

  TreeModel copyWith({
    String? id,
    String? name,
    String? species,
    String? location,
    DateTime? plantedDate,
    String? healthStatus,
    String? imageUrl,
    DateTime? lastWatered,
    DateTime? lastFertilized,
  }) {
    return TreeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      location: location ?? this.location,
      plantedDate: plantedDate ?? this.plantedDate,
      healthStatus: healthStatus ?? this.healthStatus,
      imageUrl: imageUrl ?? this.imageUrl,
      lastWatered: lastWatered ?? this.lastWatered,
      lastFertilized: lastFertilized ?? this.lastFertilized,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'location': location,
      'plantedDate': plantedDate.toIso8601String(),
      'healthStatus': healthStatus,
      'imageUrl': imageUrl,
      'lastWatered': lastWatered?.toIso8601String(),
      'lastFertilized': lastFertilized?.toIso8601String(),
    };
  }

  factory TreeModel.fromJson(Map<String, dynamic> json) {
    return TreeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      location: json['location'] as String,
      plantedDate: DateTime.parse(json['plantedDate'] as String),
      healthStatus: json['healthStatus'] as String,
      imageUrl: json['imageUrl'] as String?,
      lastWatered: json['lastWatered'] != null
          ? DateTime.parse(json['lastWatered'] as String)
          : null,
      lastFertilized: json['lastFertilized'] != null
          ? DateTime.parse(json['lastFertilized'] as String)
          : null,
    );
  }

  bool get needsWatering {
    if (lastWatered == null) return true;
    return DateTime.now().difference(lastWatered!).inDays >= 3;
  }
}