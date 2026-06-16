import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/plant_provider.dart';
import '../../data/repositories/scan_repository.dart';
import '../../services/tflite_service.dart';
import '../../services/disease_service.dart';
import '../../widgets/loading_dialog.dart';
import 'scan_result_screen.dart';
import '../../../main.dart'; // Import global services

class ScanCameraScreen extends StatefulWidget {
  const ScanCameraScreen({super.key});

  @override
  State<ScanCameraScreen> createState() => _ScanCameraScreenState();
}

class _ScanCameraScreenState extends State<ScanCameraScreen>
    with SingleTickerProviderStateMixin {
  final ScanRepository _scanRepository = ScanRepository();
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    final selectedPlant = plantProvider.selectedPlant;

    if (selectedPlant.isEmpty) {
      _showSnackbar('Silakan pilih tanaman terlebih dahulu', Colors.red);
      return;
    }

    LoadingDialog.show(context, message: 'Membuka kamera...');

    final image = await _scanRepository.pickImageFromCamera();

    if (mounted) LoadingDialog.hide(context);

    if (image != null && mounted) {
      await _diagnoseAndNavigate(image, selectedPlant);
    } else if (mounted) {
      _showSnackbar('Gagal mengambil foto', Colors.red);
    }
  }

  Future<void> _pickFromGallery() async {
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    final selectedPlant = plantProvider.selectedPlant;

    if (selectedPlant.isEmpty) {
      _showSnackbar('Silakan pilih tanaman terlebih dahulu', Colors.red);
      return;
    }

    final image = await _scanRepository.pickImageFromGallery();

    if (image != null && mounted) {
      await _diagnoseAndNavigate(image, selectedPlant);
    } else if (mounted) {
      _showSnackbar('Gagal memuat gambar', Colors.red);
    }
  }

  Future<void> _diagnoseAndNavigate(File image, String plantType) async {
    // Show loading
    LoadingDialog.show(context, message: 'Menganalisis tanaman dengan AI...');

    try {
      // Check if AI services are loaded
      if (!tfliteService.isLoaded) {
        throw Exception('Model AI belum siap. Silakan restart aplikasi.');
      }

      if (!diseaseService.isLoaded) {
        throw Exception(
            'Database penyakit belum siap. Silakan restart aplikasi.');
      }

      // Perform AI prediction
      final prediction = await tfliteService.predict(image);

      print(
          'AI Prediction - Label: ${prediction.label}, Confidence: ${prediction.confidence}');

      // Get disease details from JSON
      final diseaseData = diseaseService.getDiseaseByLabel(prediction.label);

      String diagnosisResult;
      String recommendation;

      if (diseaseData != null) {
        diagnosisResult = diseaseData.penyakit;

        // Build recommendation from disease data
        List<String> recommendations = [];
        if (diseaseData.penanganan.isNotEmpty) {
          recommendations.addAll(diseaseData.penanganan);
        }
        if (diseaseData.pencegahan.isNotEmpty) {
          recommendations.addAll(diseaseData.pencegahan);
        }
        recommendation = recommendations.isNotEmpty
            ? recommendations.join('\n\n')
            : 'Konsultasikan dengan penyuluh pertanian setempat untuk penanganan lebih lanjut.';
      } else {
        diagnosisResult = prediction.label;
        recommendation =
            'Hasil deteksi: ${prediction.label} dengan tingkat keyakinan ${(prediction.confidence * 100).toStringAsFixed(1)}%. Silakan konsultasikan dengan penyuluh pertanian.';
      }

      if (mounted) {
        LoadingDialog.hide(context);

        // Save to repository (will be saved when user clicks save in result screen)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanResultScreen(
              imagePath: image.path,
              diagnosisResult: diagnosisResult,
              confidence: prediction.confidence,
              recommendation: recommendation,
              plantType: plantType,
              predictedLabel: prediction.label, // Pass raw label for saving
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        LoadingDialog.hide(context);
        _showSnackbar('Error: $e', Colors.red);
        print('Diagnosis error: $e');
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final plantName = plantProvider.currentPlantInfo['name'];
    final plantColor = plantProvider.currentPlantInfo['color'];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [plantColor, plantColor.withValues(alpha: 0.7)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      'Scan $plantName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const Spacer(),

              // Camera Icon with Animation
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              Text(
                'Scan Tanaman $plantName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Arahkan kamera ke daun tanaman',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),

              const Spacer(),

              // Buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _takePhoto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: plantColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Ambil Foto',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        onPressed: _pickFromGallery,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Pilih dari Galeri',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
