part of 'app_theme_cubit.dart';

extension AppThemeState on ThemeMode {
  static ThemeMode initial() => ThemeMode.system;

  static ThemeMode fromString(String? value) => switch (value) {
        AppConstants.lightMode => ThemeMode.light,
        AppConstants.darkMode => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  static String asString(ThemeMode mode) => switch (mode) {
        ThemeMode.light => AppConstants.lightMode,
        ThemeMode.dark => AppConstants.darkMode,
        ThemeMode.system => AppConstants.systemMode,
      };
}
