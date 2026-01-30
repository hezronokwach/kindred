import 'package:flutter/material.dart';

class AppColors {
  // Primary Gradient: Emerald
  static const Color emeraldPrimary = Color(0xFF10B981);
  static const Color emeraldSecondary = Color(0xFF059669);
  static const Color emeraldLight = Color(0xFF34D399);

  // Backgrounds: Slate / Charcoal
  static const Color slateDark = Color(0xFF0F172A);
  static const Color slateMedium = Color(0xFF1E293B);
  static const Color slateLight = Color(0xFF334155);

  // Accents & Status
  static const Color amber = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFF43F5E);
  static const Color sky = Color(0xFF0EA5E9);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8FAFC);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray600 = Color(0xFF475569);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [emeraldPrimary, emeraldSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [slateMedium, slateDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient glassGradient(Color baseColor) {
    return LinearGradient(
      colors: [
        baseColor.withOpacity(0.1),
        baseColor.withOpacity(0.05),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
