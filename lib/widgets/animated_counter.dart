import 'package:flutter/material.dart';
import '../utils/app_typography.dart';
import '../utils/app_animations.dart';

class AnimatedCounter extends StatelessWidget {
  final num value;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;
  final int precision;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.duration = AppAnimations.medium,
    this.precision = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      curve: AppAnimations.standardCurve,
      builder: (context, val, child) {
        return Text(
          '$prefix${val.toStringAsFixed(precision)}$suffix',
          style: style ?? AppTypography.data,
        );
      },
    );
  }
}
