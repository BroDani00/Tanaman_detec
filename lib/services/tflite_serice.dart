import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import '../core/constants/app_constans.dart';

/// Service untuk mengelola model TensorFlow Lite
class TfliteService {
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isLoaded = false;

  /// Mendapatkan status apakah model sudah dimuat
  bool get isLoaded => _isLoaded;

  /// Memuat model TFLite dan file labels
  Future<void> loadModel() async {
    try {
      // Memuat model dari asset
      _interpreter = await Interpreter.fromAsset(AppConstants.modelPath);

      // Memuat file labels
      final labelsContent =
          await rootBundle.loadString(AppConstants.labelsPath);
      _labels = labelsContent
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();

      _isLoaded = true;
      print('✅ Model berhasil dimuat. ${_labels?.length} kelas tersedia');
    } catch (e) {
      print('❌ Gagal memuat model: $e');
      _isLoaded = false;
      rethrow;
    }
  }

  /// Melakukan prediksi pada gambar
  /// Mengembalikan label penyakit dan tingkat keyakinan
  Future<PredictionResult> predict(File imageFile) async {
    if (!_isLoaded) {
      throw Exception(AppConstants.errorLoadModel);
    }

    try {
      // 1. Preprocessing gambar
      final inputImage = await _preprocessImage(imageFile);

      // 2. Konversi ke tensor
      final inputTensor = _imageToTensor(inputImage);

      // 3. Siapkan output tensor
      final output = List.filled(1 * (_labels?.length ?? 0), 0.0)
          .reshape([1, _labels?.length ?? 0]);

      // 4. Jalankan inferensi
      _interpreter?.run(inputTensor, output);

      // 5. Ambil hasil dengan probabilitas tertinggi
      final probabilities = output[0] as List<double>;
      int maxIndex = 0;
      double maxProb = probabilities[0];

      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxIndex = i;
          maxProb = probabilities[i];
        }
      }

      final predictedLabel = _labels?[maxIndex] ?? 'unknown';

      return PredictionResult(
        label: predictedLabel,
        confidence: maxProb,
      );
    } catch (e) {
      print('❌ Error prediksi: $e');
      throw Exception('${AppConstants.errorPredict}: $e');
    }
  }

  /// Preprocessing gambar: resize ke ukuran yang diinginkan model
  Future<img.Image> _preprocessImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? original = img.decodeImage(bytes);

    if (original == null) {
      throw Exception(AppConstants.errorNoImage);
    }

    // Resize gambar sesuai input model
    img.Image resized = img.copyResize(
      original,
      width: AppConstants.modelInputSize,
      height: AppConstants.modelInputSize,
    );

    return resized;
  }

  /// Konversi gambar ke format tensor yang dapat diproses model
  List<List<List<List<double>>>> _imageToTensor(img.Image image) {
    final inputSize = AppConstants.modelInputSize;

    // Membuat tensor dengan shape [1, height, width, 3]
    var input = List.generate(
      1,
      (i) => List.generate(
        inputSize,
        (j) => List.generate(
          inputSize,
          (k) => List.generate(3, (l) => 0.0),
        ),
      ),
    );

    // Normalisasi pixel ke range [0, 1]
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = image.getPixel(x, y);
        input[0][y][x][0] = pixel / 255.0; // Red
        input[0][y][x][1] = pixel / 255.0; // Green
        input[0][y][x][2] = pixel / 255.0; // Blue
      }
    }

    return input;
  }

  /// Menutup interpreter dan membersihkan resource
  void dispose() {
    _interpreter?.close();
    _isLoaded = false;
  }
}

/// Kelas hasil prediksi
class PredictionResult {
  final String label;
  final double confidence;

  PredictionResult({
    required this.label,
    required this.confidence,
  });
}
