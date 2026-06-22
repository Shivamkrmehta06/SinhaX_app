import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primarySurface = Color(0xFFEFF6FF);

  // Gradient stops
  static const List<Color> primaryGradient = [
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
  ];

  static const List<Color> heroGradient = [
    Color(0xFF1E40AF),
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
  ];

  // Semantic colors
  static const Color success = Color(0xFF22C55E);
  static const Color successSurface = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSurface = Color(0xFFFEF2F2);

  // Neutrals
  static const Color background = Color(0xFFF8FAFC);
  static const Color white = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Chart colors
  static const Color chartLine = Color(0xFF2563EB);
  static const Color chartFill = Color(0x1A2563EB);
  static const Color chartPositive = Color(0xFF22C55E);
  static const Color chartNegative = Color(0xFFEF4444);
}
