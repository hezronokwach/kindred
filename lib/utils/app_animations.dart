import 'package:flutter/material.dart';

class AppAnimations {
  // Curves
  static const Curve standardCurve = Curves.easeOutQuart;
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve fluidCurve = Curves.easeInOutCubic;

  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 800);

  // Common Tweens
  static final Tween<double> scaleTween = Tween<double>(begin: 0.95, end: 1.0);
  static final Tween<double> fadeTween = Tween<double>(begin: 0.0, end: 1.0);
  static final Tween<Offset> slideUpTween = Tween<Offset>(
    begin: const Offset(0, 0.1),
    end: Offset.zero,
  );
}
