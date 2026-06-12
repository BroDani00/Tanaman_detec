// lib/screens/scan/scan_result_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/repositories/scan_repository.dart';
import '../../providers/plant_provider.dart';
import '../../widgets/loading_dialog.dart';

class ScanResultScreen extends StatefulWidget {
  final String imagePath;
  final String diagnosisResult;
  final double confidence;
  final String recommendation;
  final String plantType;

  const ScanResultScreen({
    super.key,
    required this.imagePath,
    required this.diagnosisResult,
    required this.confidence,
    required this.recommendation,
    required this.plantType,
  });

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  final TextEditingController _notesController = TextEditingController();
  final ScanRepository _scanRepository = ScanRepository();
  bool _isSaved = false;

  Color get _statusColor {
    if (widget.diagnosisResult.contains('Sehat')) return AppColors.success;
    if (widget.diagnosisResult.contains('Bercak') ||
        widget.diagnosisResult.contains('Layu')) {
      return AppColors.warning;
    }
    return AppColors.error;
  }

  IconData get _statusIcon {
    if (widget.diagnosisResult.contains('Sehat')) return Icons.check_circle;
    if (widget.diagnosisResult.contains('Bercak') ||
        widget.diagnosisResult.contains('Layu')) {
      return Icons.warning_amber;
    }
    return Icons.error;
  }

  Future<void> _saveToHistory() async {
    LoadingDialog.show(context, message: 'Menyimpan...');

    await _scanRepository.saveScanResult(
      imagePath: widget.imagePath,
      plantType: widget.plantType,
      diagnosisResult: widget.diagnosisResult,
      confidence: widget.confidence,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    if (mounted) LoadingDialog.hide(context);

    setState(() => _isSaved = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hasil scan telah disimpan'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final plantColor = plantProvider.currentPlantInfo['color'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Scan'),
        backgroundColor: AppColors.primary,
        actions: [
          if (!_isSaved)
            TextButton.icon(
              onPressed: _saveToHistory,
              icon: const Icon(Icons.save, color: Colors.white),
              label:
                  const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            widget.plantType.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Result Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: _statusColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Icon(_statusIcon, size: 60, color: _statusColor),
                    const SizedBox(height: 12),
                    Text(
                      widget.diagnosisResult,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _statusColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Tingkat Keyakinan: ${(widget.confidence * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.lightbulb, size: 20, color: _statusColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Rekomendasi:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.recommendation,
                      style: const TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Notes Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Catatan Tambahan',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Daun mulai menguning dari tepi...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Scan Ulang'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (!_isSaved)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _saveToHistory,
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
