class StaticData {
  static const List<String> treeSpecies = [
    'Oak (Quercus)',
    'Maple (Acer)',
    'Pine (Pinus)',
    'Apple (Malus domestica)',
    'Cherry (Prunus)',
    'Birch (Betula)',
    'Willow (Salix)',
    'Cedar (Cedrus)',
    'Elm (Ulmus)',
    'Ash (Fraxinus)',
  ];

  static const List<String> careTypes = [
    'Watering',
    'Fertilizing',
    'Pruning',
    'Pest Control',
    'Mulching',
    'Inspection',
    'Other',
  ];

  static const List<String> healthStatuses = [
    'Healthy',
    'Needs Attention',
    'Critical',
  ];

  static const Map<String, int> wateringFrequency = {
    'Daily': 1,
    'Every 2 days': 2,
    'Every 3 days': 3,
    'Weekly': 7,
    'Bi-weekly': 14,
  };
}