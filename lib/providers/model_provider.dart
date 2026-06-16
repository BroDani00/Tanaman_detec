import 'package:flutter/material.dart';
import '../services/tflite_service.dart';
import '../services/disease_service.dart';

class ModelProvider extends ChangeNotifier {
  late TfliteService _tfliteService;
  late DiseaseService _diseaseService;
  bool _isLoaded = false;
  String? _errorMessage;

  TfliteService get tflite => _tfliteService;
  DiseaseService get disease => _diseaseService;
  bool get isLoaded => _isLoaded;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    _tfliteService = TfliteService();
    _diseaseService = DiseaseService();

    try {
      await Future.wait([
        _tfliteService.loadModel(),
        _diseaseService.loadDiseaseData(),
      ]);
      _isLoaded = true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoaded = false;
    }
    notifyListeners();
  }

  void dispose() {
    _tfliteService.dispose();
    super.dispose();
  }
}
