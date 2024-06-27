import 'package:flutter/material.dart';

import 'app_color.dart';
import 'color_schemes.dart';

class AppTheme {
  AppTheme();

  static ThemeData get lightTheme => baseTheme(AppColorScheme.lightColorScheme);
  static ThemeData get darkTheme => baseTheme(AppColorScheme.darkColorScheme);

  static ThemeData baseTheme(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      cardTheme: CardTheme(
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      chipTheme: const ChipThemeData(
        padding: EdgeInsets.all(20),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(15),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: AppColor.white,
        surfaceTintColor: AppColor.white,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColor.white, surfaceTintColor: AppColor.white),
    );
  }
}
