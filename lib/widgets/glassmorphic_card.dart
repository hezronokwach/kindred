import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_theme.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: padding ?? const EdgeInsets.all(24),
            decoration: AppTheme.glassDecoration(
              borderRadius: borderRadius,
              color: color,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
