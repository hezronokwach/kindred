import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';

class LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.slateLight.withOpacity(0.3),
      highlightColor: AppColors.slateLight.withOpacity(0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  static Widget card() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingSkeleton(width: 150, height: 24),
          const SizedBox(height: 20),
          const LoadingSkeleton(height: 100),
          const SizedBox(height: 12),
          Row(
            children: [
              const LoadingSkeleton(width: 80, height: 16),
              const SizedBox(width: 12),
              const LoadingSkeleton(width: 80, height: 16),
            ],
          )
        ],
      ),
    );
  }
}
