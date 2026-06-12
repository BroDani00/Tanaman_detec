// lib/data/repositories/scan_repository.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';
import '../models/scan_history_model.dart';
import '../../services/storage_service.dart';
import '../../providers/plant_provider.dart';

class ScanRepository {
  final ImagePicker _picker = ImagePicker();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final StorageService _storage = StorageService();

  // Pick image from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      print('Error picking image from camera: $e');
    }
    return null;
  }

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
    return null;
  }

  // Dummy diagnosis (will be replaced with TFLite later)
  Future<Map<String, dynamic>> diagnoseDisease(
      File image, String plantType) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate processing

    // Dummy result - random between healthy and some diseases
    final List<String> possibleResults = [
      'Tanaman Sehat',
      'Penyakit Bercak Daun',
      'Penyakit Layu Bakteri',
      'Penyakit Virus Keriting',
    ];

    final random = DateTime.now().millisecondsSinceEpoch % 4;
    final diagnosis = possibleResults[random.toInt()];
    final confidence =
        diagnosis == 'Tanaman Sehat' ? 0.95 : 0.75 + (random * 0.05);

    return {
      'diagnosis': diagnosis,
      'confidence': confidence.clamp(0.0, 1.0),
      'recommendation': _getRecommendation(diagnosis, plantType),
    };
  }

  String _getRecommendation(String diagnosis, String plantType) {
    if (diagnosis == 'Tanaman Sehat') {
      return 'Tanaman Anda dalam kondisi baik. Lanjutkan perawatan seperti biasa.';
    } else if (diagnosis == 'Penyakit Bercak Daun') {
      return 'Segera buang daun yang terserang. Semprot dengan fungisida berbahan aktif tembaga. Jaga sirkulasi udara.';
    } else if (diagnosis == 'Penyakit Layu Bakteri') {
      return 'Cabut dan bakar tanaman terserang. Gunakan varietas tahan penyakit. Rotasi tanaman.';
    } else {
      return 'Segera konsultasikan ke penyuluh pertanian terdekat. Hindari penggunaan pestisida berlebihan.';
    }
  }

  // Save scan result to database
  Future<void> saveScanResult({
    required String imagePath,
    required String plantType,
    required String diagnosisResult,
    required double confidence,
    String? notes,
  }) async {
    final userId = _storage.userId;
    if (userId == null) return;

    final scan = ScanHistoryModel(
      userId: userId,
      plantType: plantType,
      imagePath: imagePath,
      diagnosisResult: diagnosisResult,
      confidence: confidence,
      scanDate: DateTime.now(),
      notes: notes,
    );

    await _dbHelper.insertScanHistory(scan);
  }

  // Get all scan history for current user
  Future<List<ScanHistoryModel>> getUserScanHistory() async {
    final userId = _storage.userId;
    if (userId == null) return [];

    return await _dbHelper.getScanHistoryByUserId(userId);
  }

  // Delete scan history
  Future<void> deleteScanHistory(int id) async {
    await _dbHelper.deleteScanHistory(id);
  }
}
