import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  static TextStyle _dmSans({
    required double fontSize,
    required FontWeight fontWeight,
    double? letterSpacing,
    double? height,
    Color? color,
  }) =>
      GoogleFonts.dmSans(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
        color: color,
      );

  // Display
  static TextStyle get displayLarge => _dmSans(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      );

  static TextStyle get displayMedium => _dmSans(
        fontSize: 45,
        fontWeight: FontWeight.w400,
      );

  // Headline
  static TextStyle get headlineLarge => _dmSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineMedium => _dmSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get headlineSmall => _dmSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      );

  // Title
  static TextStyle get titleLarge => _dmSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMedium => _dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      );

  static TextStyle get titleSmall => _dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  // Body
  static TextStyle get bodyLarge => _dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.6,
      );

  static TextStyle get bodyMedium => _dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle get bodySmall => _dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.5,
      );

  // Label
  static TextStyle get labelLarge => _dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => _dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => _dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  // Brand
  static TextStyle get brandTitle => _dmSans(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: AppColors.primary,
      );
}
