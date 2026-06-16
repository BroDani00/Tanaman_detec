import 'dart:convert';
import 'package:flutter/services.dart';

class DiseaseRepository {
  Future<Map<String, dynamic>?> getDiseaseByLabel(String label) async {
    final jsonString = await rootBundle.loadString(
      'assets/data/disease_data.json',
    );

    final List data = json.decode(jsonString);

    try {
      return data.firstWhere(
        (item) => item['label'] == label,
      );
    } catch (_) {
      return null;
    }
  }
}

