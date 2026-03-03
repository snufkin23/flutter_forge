import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFFE94560); // red
  static const Color secondary = Color(0xFFF5A623); // orange
  static const Color dark = Color(0xFF1A1A2E); // dark navy

  // Light theme
  static const Color lightBackground = Color(0xFFF8F8F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF1A1A2E);
  static const Color lightOnSurface = Color(0xFF2D2D2D);
  static const Color lightSubtext = Color(0xFF7A7A7A);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Dark theme
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkOnBackground = Color(0xFFF8F8F8);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkSubtext = Color(0xFF9A9A9A);
  static const Color darkDivider = Color(0xFF2D2D2D);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE94560);
  static const Color info = Color(0xFF2196F3);
}
