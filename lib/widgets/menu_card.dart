// lib/widgets/menu_card.dart

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isDisabled;

  const MenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = constraints.maxHeight;

        final iconSize = cardHeight * 0.18;
        final circlePadding = cardHeight * 0.08;

        return Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isDisabled ? null : onTap,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.all(circlePadding),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: iconSize,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Center(
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
