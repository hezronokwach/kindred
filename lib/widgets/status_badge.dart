import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
  });

  factory StatusBadge.stock(int stock) {
    if (stock <= 5) {
      return const StatusBadge(label: 'Low Stock', color: AppColors.rose);
    } else if (stock <= 20) {
      return const StatusBadge(label: 'Medium', color: AppColors.amber);
    } else {
      return const StatusBadge(label: 'In Stock', color: AppColors.emeraldPrimary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.caption.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
