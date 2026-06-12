// lib/data/models/plant_model.dart
class PlantModel {
  final int? id;
  final int userId;
  final String plantType; // cabai, jagung, padi
  final String plantName;
  final DateTime plantingDate;
  final String? notes;

  PlantModel({
    this.id,
    required this.userId,
    required this.plantType,
    required this.plantName,
    required this.plantingDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'plant_type': plantType,
      'plant_name': plantName,
      'planting_date': plantingDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory PlantModel.fromMap(Map<String, dynamic> map) {
    return PlantModel(
      id: map['id'],
      userId: map['user_id'],
      plantType: map['plant_type'],
      plantName: map['plant_name'],
      plantingDate: DateTime.parse(map['planting_date']),
      notes: map['notes'],
    );
  }

  int get plantAgeInDays {
    return DateTime.now().difference(plantingDate).inDays;
  }
}
