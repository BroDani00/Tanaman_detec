// lib/widgets/scan_history_card.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/models/scan_history_model.dart';

class ScanHistoryCard extends StatelessWidget {
  final ScanHistoryModel scan;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  
  const ScanHistoryCard({
    super.key,
    required this.scan,
    required this.onTap,
    required this.onDelete,
  });
  
  @override
  Widget build(BuildContext context) {
    // Determine color based on diagnosis
    Color getStatusColor() {
      if (scan.diagnosisResult.contains('Sehat')) return AppColors.success;
      if (scan.diagnosisResult.contains('Bercak') || scan.diagnosisResult.contains('Layu')) {
        return AppColors.warning;
      }
      return AppColors.error;
    }
    
    Color getPlantColor() {
      switch (scan.plantType) {
        case 'cabai': return AppColors.cabai;
        case 'jagung': return AppColors.jagung;
        case 'padi': return AppColors.padi;
        default: return AppColors.primary;
      }
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(scan.imagePath),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: getPlantColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            scan.plantType.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: getPlantColor(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: getStatusColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            scan.confidencePercent,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: getStatusColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      scan.diagnosisResult,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scan.formattedDate,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.grey,
                      ),
                    ),
                    if (scan.notes != null && scan.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          scan.notes!,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              
              // Delete button
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                iconSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}