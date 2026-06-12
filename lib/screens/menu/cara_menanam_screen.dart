// lib/screens/menu/cara_menanam_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/plant_provider.dart';

class CaraMenanamScreen extends StatelessWidget {
  const CaraMenanamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cara Menanam'),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<PlantProvider>(
        builder: (context, plantProvider, child) {
          final content = plantProvider.getPlantSpecificContent('cara_menanam');
          final plantName = plantProvider.currentPlantInfo['name'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: plantProvider.currentPlantInfo['color']
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        plantProvider.currentPlantInfo['icon'],
                        size: 40,
                        color: plantProvider.currentPlantInfo['color'],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Panduan Menanam $plantName',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ikuti langkah-langkah berikut untuk hasil optimal',
                              style: TextStyle(color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  content,
                  style: const TextStyle(height: 1.8, fontSize: 15),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tips: Gunakan bibit unggul dan perhatikan musim tanam yang tepat.',
                          style: TextStyle(color: Colors.amber[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
