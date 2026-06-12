// lib/widgets/plant_selector.dart
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class PlantSelector extends StatefulWidget {
  final String selectedPlant;
  final Function(String) onPlantSelected;
  final bool isRequired; // Jika true, harus pilih tanaman dulu

  const PlantSelector({
    super.key,
    required this.selectedPlant,
    required this.onPlantSelected,
    this.isRequired = true,
  });

  @override
  State<PlantSelector> createState() => _PlantSelectorState();
}

class _PlantSelectorState extends State<PlantSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<PlantItem> plants = [
    PlantItem(
        id: 'cabai',
        name: 'Cabai',
        icon: Icons.local_fire_department,
        color: AppColors.cabai,
        imageAsset: 'assets/images/cabai.jpg'),
    PlantItem(
        id: 'jagung',
        name: 'Jagung',
        icon: Icons.grass,
        color: AppColors.jagung,
        imageAsset: 'assets/images/jagung.jpg'),
    PlantItem(
        id: 'padi',
        name: 'Padi',
        icon: Icons.eco,
        color: AppColors.padi,
        imageAsset: 'assets/images/padi.jpg'),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPlantTap(String plantId) {
    _animationController.forward(from: 0);
    widget.onPlantSelected(plantId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: plants.map((plant) {
            final isSelected = widget.selectedPlant == plant.id;
            final size = isSelected ? 85.0 : 65.0;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: GestureDetector(
                onTap: () => _onPlantTap(plant.id),
                child: Column(
                  children: [
                    Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isSelected ? plant.color : Colors.grey.shade300,
                          width: isSelected ? 4 : 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: plant.color.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          plant.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: plant.color.withValues(alpha: 0.2),
                              child: Icon(
                                plant.icon,
                                size: size * 0.4,
                                color: plant.color,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: isSelected ? 14 : 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? plant.color : AppColors.grey,
                      ),
                      child: Text(plant.name),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.isRequired && widget.selectedPlant.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber, size: 16, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Text(
                    'Silakan pilih tanaman terlebih dahulu',
                    style: TextStyle(fontSize: 12, color: AppColors.warning),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class PlantItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String imageAsset;

  PlantItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.imageAsset,
  });
}
