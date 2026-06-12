// lib/data/models/scan_history_model.dart
class ScanHistoryModel {
  final int? id;
  final int userId;
  final String plantType; // cabai, jagung, padi
  final String imagePath;
  final String diagnosisResult;
  final double confidence;
  final DateTime scanDate;
  final String? notes;

  ScanHistoryModel({
    this.id,
    required this.userId,
    required this.plantType,
    required this.imagePath,
    required this.diagnosisResult,
    required this.confidence,
    required this.scanDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'plant_type': plantType,
      'image_path': imagePath,
      'diagnosis_result': diagnosisResult,
      'confidence': confidence,
      'scan_date': scanDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory ScanHistoryModel.fromMap(Map<String, dynamic> map) {
    return ScanHistoryModel(
      id: map['id'],
      userId: map['user_id'],
      plantType: map['plant_type'],
      imagePath: map['image_path'],
      diagnosisResult: map['diagnosis_result'],
      confidence: map['confidence'],
      scanDate: DateTime.parse(map['scan_date']),
      notes: map['notes'],
    );
  }

  String get formattedDate {
    return '${scanDate.day}/${scanDate.month}/${scanDate.year} ${scanDate.hour.toString().padLeft(2, '0')}:${scanDate.minute.toString().padLeft(2, '0')}';
  }

  String get confidencePercent => '${(confidence * 100).toInt()}%';
}
