import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

abstract class AppSizes {
  // —— Spacing ——————————————————————————
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;
  static double get xxxl => 32.w;
  static double get xxxxl => 40.w;
  static double get xxxxxl => 48.w;

  // —— Padding presets ——————————————————
  static double get pagePadding => 24.w;
  static double get cardPadding => 16.w;
  static double get inputPadding => 14.w;
  static double get sectionSpacing => 32.h;
  static double get itemSpacing => 12.h;

  // —— Border Radius ————————————————————
  static double get radiusXs => 4.r;
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 24.r;
  static double get radiusFull => 999.r;

  // —— Icon Sizes ———————————————————————
  static double get iconXs => 14.w;
  static double get iconSm => 18.w;
  static double get iconMd => 24.w;
  static double get iconLg => 32.w;
  static double get iconXl => 48.w;
  static double get iconXxl => 64.w;

  // —— Button ———————————————————————————
  static double get buttonHeight => 52.h;
  static double get buttonHeightSm => 40.h;
  static double get buttonHeightLg => 60.h;

  // —— Input ————————————————————————————
  static double get inputHeight => 52.h;

  // —— AppBar ———————————————————————————
  static double get appBarHeight => 56.h;

  // —— Avatar ———————————————————————————
  static double get avatarSm => 32.w;
  static double get avatarMd => 48.w;
  static double get avatarLg => 72.w;
  static double get avatarXl => 96.w;

  // —— Card —————————————————————————————
  static double get cardElevation => 2;
  static double get cardElevationHigh => 8;

  // —— Divider ——————————————————————————
  static double get dividerThickness => 1;

  // —— Bottom Nav ———————————————————————
  static double get bottomNavHeight => 64.h;

  // —— Onboarding ———————————————————————
  static double get onboardingIllustrationSize => 220.w;
}
