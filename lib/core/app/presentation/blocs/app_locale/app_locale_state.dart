part of 'app_locale_cubit.dart';

enum AppLocale {
  en('English', '🇬🇧', 'EN'),
  ne('नेपाली', '🇳🇵', 'NP');

  const AppLocale(this.displayName, this.flag, this.short);

  final String displayName;
  final String flag;
  final String short;

  /// Convert to Flutter Locale
  Locale get locale => Locale(name);

  /// Convert from language code string
  static AppLocale fromCode(String? code) => switch (code) {
        'ne' => AppLocale.ne,
        _ => AppLocale.en,
      };
}
