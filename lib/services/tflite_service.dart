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
      
      // Debug: print input output details
      print('✅ Model loaded successfully');
      print('Input tensor shape: ${_interpreter?.getInputTensor(0).shape}');
      print('Output tensor shape: ${_interpreter?.getOutputTensor(0).shape}');

      // Memuat file labels
      final labelsContent = await rootBundle.loadString(AppConstants.labelsPath);
      _labels = labelsContent
          .split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();

      _isLoaded = true;
      print('✅ Model berhasil dimuat. ${_labels?.length} kelas tersedia');
      print('Labels: $_labels');
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

      // Debug input shape
      print('Input tensor shape: ${inputTensor.length} x ${inputTensor[0].length} x ${inputTensor[0][0].length} x ${inputTensor[0][0][0].length}');

      // 3. Siapkan output tensor
      final output = List.filled(1 * (_labels?.length ?? 0), 0.0)
          .reshape([1, _labels?.length ?? 0]);

      // 4. Jalankan inferensi
      _interpreter?.run(inputTensor, output);

      // 5. Ambil hasil dengan probabilitas tertinggi
      final probabilities = output[0] as List<double>;
      
      // Debug: print semua probabilitas
      print('Probabilities: $probabilities');
      
      int maxIndex = 0;
      double maxProb = probabilities[0];

      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxIndex = i;
          maxProb = probabilities[i];
        }
      }

      String predictedLabel = _labels?[maxIndex] ?? 'unknown';
      
      // Clean label (remove index number if exists)
      predictedLabel = predictedLabel.replaceAll(RegExp(r'^\d+\s+'), '');
      
      print('Predicted: $predictedLabel with confidence ${(maxProb * 100).toStringAsFixed(2)}%');

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
  /// Format: [1, height, width, 3] dengan nilai float 0.0 - 1.0
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
        
        // Extract RGB values correctly
        int r = img.getRed(pixel);
        int g = img.getGreen(pixel);
        int b = img.getBlue(pixel);
        
        // Normalize to [0,1]
        input[0][y][x][0] = r / 255.0;
        input[0][y][x][1] = g / 255.0;
        input[0][y][x][2] = b / 255.0;
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