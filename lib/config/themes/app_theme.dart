import 'package:flutter/material.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/config/themes/font_manager.dart';

// Provides the app-wide Material theme built on the Mishkat palette.
class AppTheme {
  AppTheme._();

  // Builds the light theme used across the whole app.
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: FontManager.ui,
      scaffoldBackgroundColor: ColorsManager.greyBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorsManager.primary,
        primary: ColorsManager.primary,
        secondary: ColorsManager.secondry,
        surface: ColorsManager.surface,
        onSurface: ColorsManager.onSurface,
        error: ColorsManager.red,
      ),
      splashFactory: InkSparkle.splashFactory,
      dividerColor: ColorsManager.divider,
      sliderTheme: const SliderThemeData(
        activeTrackColor: ColorsManager.secondry,
        thumbColor: ColorsManager.secondry,
        inactiveTrackColor: ColorsManager.whiteBorder,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ColorsManager.surface,
        surfaceTintColor: ColorsManager.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: ColorsManager.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
