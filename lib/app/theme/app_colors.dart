import 'package:flutter/material.dart';

class AppColors {
  // Brand & Primary
  static const Color primaryBlue = Color(0xFF0055C9);
  static Color primaryBlueLight = const Color(0xFFDAE2FF).withValues(alpha: 0.7);

  // Typography & Icons
  static const Color textPrimary = Color(0xFF000719);
  static const Color textSecondary = Color(0xFF44474D);
  static const Color textTertiary = Color(0xFF75777E);

  // Surfaces & Backgrounds
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color backgroundMain = Color(0xFFF5FAFF);
  static Color backgroundMainTranslucent = const Color(0xFFF5FAFF).withValues(alpha: 0.8);
  static const Color backgroundSoft = Color(0xFFEFF4F9);
  static const Color backgroundMuted = Color(0xFFE9EEF3);

  // Borders & Lines
  static const Color dividerGray = Color(0xFFC5C6CE);
}