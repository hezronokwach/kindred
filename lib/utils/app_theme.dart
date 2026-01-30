import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_animations.dart';

class AppTheme {
  // Theme getter
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.slateDark,
      primaryColor: AppColors.emeraldPrimary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.emeraldPrimary,
        secondary: AppColors.emeraldSecondary,
        surface: AppColors.slateMedium,
        onSurface: AppColors.white,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTypography.headline,
        titleLarge: AppTypography.title,
        bodyLarge: AppTypography.body,
        bodySmall: AppTypography.caption,
        labelLarge: AppTypography.button,
      ),
      cardTheme: CardThemeData(
        color: AppColors.slateMedium.withOpacity(0.7),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
    );
  }

  // Glass Container Decoration
  static BoxDecoration glassDecoration({
    double borderRadius = 20,
    Color? color,
    Border? border,
  }) {
    return BoxDecoration(
      color: (color ?? AppColors.slateMedium).withOpacity(0.1),
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ??
          Border.all(
            color: AppColors.white.withOpacity(0.1),
            width: 1,
          ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // Emerald Button Decoration
  static BoxDecoration emeraldButton({bool isPressed = false}) {
    return BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: BorderRadius.circular(16),
      boxShadow: isPressed
          ? [
              BoxShadow(
                color: AppColors.emeraldPrimary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ]
          : [
              BoxShadow(
                color: AppColors.emeraldPrimary.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
    );
  }

  // Legacy compatibility mapping
  static const Color black = AppColors.slateDark;
  static const Color white = AppColors.white;
  static const Color emerald = AppColors.emeraldPrimary;
  static const Color orange = AppColors.amber;
  
  static BoxDecoration whiteCard({double borderRadius = 20}) => glassDecoration(borderRadius: borderRadius);
  static BoxDecoration blackCard({double borderRadius = 20}) => glassDecoration(borderRadius: borderRadius, color: AppColors.slateDark);
  static BoxDecoration orangeButton({bool isPressed = false}) => emeraldButton(isPressed: isPressed);
  
  static const Duration fast = AppAnimations.fast;
  static const Duration medium = AppAnimations.medium;
  static const Duration slow = AppAnimations.slow;
  
  static const double xs = 8.0;
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double lg = 32.0;

  static final TextStyle heroText = AppTypography.headline;
  static final TextStyle narrativeText = AppTypography.title;
  static final TextStyle dataText = AppTypography.body;
  static final TextStyle buttonText = AppTypography.button;
}
