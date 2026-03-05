import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

abstract class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.error,
          onSecondary: Colors.white,
          onSurface: AppColors.lightOnSurface,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        textTheme: _textTheme(AppColors.lightOnBackground),
        appBarTheme: _appBarTheme(
          backgroundColor: AppColors.lightSurface,
          foregroundColor: AppColors.lightOnBackground,
        ),
        elevatedButtonTheme: _elevatedButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(
          borderColor: AppColors.lightDivider,
          labelColor: AppColors.lightSubtext,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.lightDivider,
          thickness: 1,
        ),
        cardTheme: CardThemeData(
          color: AppColors.lightSurface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.darkSurface,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.darkOnSurface,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        textTheme: _textTheme(AppColors.darkOnBackground),
        appBarTheme: _appBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkOnBackground,
        ),
        elevatedButtonTheme: _elevatedButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(
          borderColor: AppColors.darkDivider,
          labelColor: AppColors.darkSubtext,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkDivider,
          thickness: 1,
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  // —— Private helpers ——————————————————————————

  static TextTheme _textTheme(Color color) => TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: color),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: color),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: color),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: color),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: color),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: color),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: color),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: color),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: color),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: color),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: color),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: color),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: color),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: color),
      );

  static AppBarTheme _appBarTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) =>
      AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleLarge.copyWith(
          color: foregroundColor,
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      );

  static InputDecorationTheme _inputDecorationTheme({
    required Color borderColor,
    required Color labelColor,
  }) =>
      InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: labelColor),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: labelColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      );
}
