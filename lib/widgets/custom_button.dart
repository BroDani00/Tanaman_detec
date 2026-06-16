import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [
                    Color(0xFF2E7D32),
                    Color(0xFF43A047),
                  ],
                )
              : null,
          color: isPrimary ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon != null
              ? Icon(icon, color: isPrimary ? Colors.white : Colors.green)
              : const SizedBox(),
          label: Text(
            text,
            style: TextStyle(
              color: isPrimary ? Colors.white : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
