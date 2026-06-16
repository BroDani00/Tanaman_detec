import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import '../database/database_helper.dart';
import '../models/scan_history_model.dart';
import '../../services/storage_service.dart';
import '../../services/tflite_service.dart';
import '../../services/disease_service.dart';
import '../../data/models/disease_model.dart';

class ScanRepository {
  final ImagePicker _picker = ImagePicker();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final StorageService _storage = StorageService();

  // Pick image from camera dengan kualitas lebih baik
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Turunkan sedikit untuk stabilitas
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        // Validasi dan konversi gambar jika perlu
        return await _validateAndConvertImage(File(image.path));
      }
    } catch (e) {
      print('Error picking image from camera: $e');
    }
    return null;
  }

  // Pick image from gallery dengan kualitas lebih baik
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        return await _validateAndConvertImage(File(image.path));
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
    return null;
  }

  // Validasi dan konversi gambar ke format yang kompatibel
  Future<File> _validateAndConvertImage(File imageFile) async {
    try {
      // Baca bytes gambar
      final bytes = await imageFile.readAsBytes();

      // Coba decode dengan library image
      img.Image? decoded = img.decodeImage(bytes);

      if (decoded == null) {
        // Jika gagal decode, coba simpan ulang sebagai PNG
        print('Gambar corrupt, mencoba konversi...');
        final tempDir = await getTemporaryDirectory();
        final newPath =
            '${tempDir.path}/converted_${DateTime.now().millisecondsSinceEpoch}.png';

        // Buat file PNG baru
        final newFile = File(newPath);
        await newFile.writeAsBytes(bytes);

        // Coba decode ulang
        final newBytes = await newFile.readAsBytes();
        decoded = img.decodeImage(newBytes);

        if (decoded == null) {
          throw Exception('Gambar tidak valid setelah konversi');
        }

        // Simpan sebagai PNG (lebih stabil)
        final pngBytes = img.encodePng(decoded);
        await newFile.writeAsBytes(pngBytes);
        return newFile;
      }

      return imageFile;
    } catch (e) {
      print('Error validating image: $e');
      rethrow;
    }
  }

  // Diagnosis dengan AI (sama seperti sebelumnya)
  Future<Map<String, dynamic>> diagnoseWithAI(
    File image,
    String plantType,
    TfliteService tflite,
    DiseaseService diseaseService,
  ) async {
    final PredictionResult prediction = await tflite.predict(image);
    final DiseaseModel? disease =
        diseaseService.getDiseaseByLabel(prediction.label);

    if (disease != null) {
      final recommendation = '''
Penyakit: ${disease.penyakit}
Deskripsi: ${disease.deskripsi}

Gejala:
${disease.gejala.map((g) => '- $g').join('\n')}

Penyebab:
${disease.penyebab.map((p) => '- $p').join('\n')}

Penanganan:
${disease.penanganan.map((pn) => '- $pn').join('\n')}

Pencegahan:
${disease.pencegahan.map((pc) => '- $pc').join('\n')}
''';
      return {
        'diagnosis': disease.penyakit,
        'confidence': prediction.confidence,
        'recommendation': recommendation,
        'diseaseData': disease,
      };
    } else {
      return {
        'diagnosis': prediction.label,
        'confidence': prediction.confidence,
        'recommendation':
            'Tidak ditemukan informasi detail untuk penyakit ini. Konsultasikan dengan ahli pertanian.',
      };
    }
  }

  // Save scan result
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
