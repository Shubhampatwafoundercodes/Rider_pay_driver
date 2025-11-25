import 'package:flutter/material.dart';
import 'package:rider_pay_driver/core/res/app_color.dart';

class AppTheme {
  /// Light Theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.lightBackground,
    primaryColor: AppColor.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColor.primary,
      secondary: AppColor.primary,
      surface: AppColor.lightSurface,
      background: AppColor.lightBackground,
      onPrimary: AppColor.white,
      onSecondary: AppColor.white,
      onSurface: AppColor.textPrimaryLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.lightSurface,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.black),
      titleTextStyle: TextStyle(
        color: AppColor.textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColor.textPrimaryLight),
      bodyMedium: TextStyle(color: AppColor.textSecondaryLight),
      labelSmall: TextStyle(color: AppColor.textSecondaryLight),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.lightSurface,
      hintStyle: const TextStyle(color: AppColor.hintLight),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.borderLight, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.primary, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  /// Dark Theme
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.darkBackground,
    primaryColor: AppColor.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColor.primary,
      secondary: AppColor.primary,
      surface: AppColor.darkSurface,
      background: AppColor.darkBackground,
      onPrimary: AppColor.white,
      onSecondary: AppColor.white,
      onSurface: AppColor.textPrimaryDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.darkSurface,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.white),
      titleTextStyle: TextStyle(
        color: AppColor.textPrimaryDark,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColor.textPrimaryDark),
      bodyMedium: TextStyle(color: AppColor.textSecondaryDark),
      labelSmall: TextStyle(color: AppColor.textSecondaryDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.darkSurface,
      hintStyle: const TextStyle(color: AppColor.hintDark),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.borderDark, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.primary, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
