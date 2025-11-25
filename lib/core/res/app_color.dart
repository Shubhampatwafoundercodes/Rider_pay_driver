import 'dart:ui';

import 'package:flutter/material.dart';


/// 🎨 AppColor - Brand + neutrals + state colors
class AppColor {
  // Brand
  static const Color primary = Color(0xFFFFC107);  // Rapido Yellow
  static const Color primaryDark = Color(0xFFFFA000);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Backgrounds
  static const Color lightBackground = Color(0xFFFCFCFC);
  // static const Color lightBackground = Color(0xFFF9FAFB); // Light bg
  static const Color darkBackground = Color(0xFF121212);  // Dark bg

  // Surfaces (cards, appbars)
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF1E1E1E);

  // Borders
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF2C2C2C);

  // Dividers
  static const Color dividerLight = Color(0xFFE5E5E5);
  static const Color dividerDark = Color(0xFF2E2E2E);

  // Grays
  // static const Color greyLight = Color(0xFFF2F2F2);
  static const Color greyLightest = Color(0xFFF5F5F5);
  static const Color greyLight = Color(0xFFf7f8fa);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyDark = Color(0xFF616161);

  // Text
  static const Color textPrimaryLight = Color(0xFF111111);
  static const Color textSecondaryLight = Color(0xFF4F4F4F);

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);
  // Text - tertiary
  static const Color textThirdLight = Color(0xFF666666); // thoda lighter black
  static const Color textThirdDark = Color(0xFFA0A0A0);


// 🔹 Disabled states (light & dark)
  static const Color disabledLight = Color(0xFFe0e0e0); // halka grey (light mode)
  static const Color disabledDark = Color(0xFF4F4F4F);


  // Hints
  static const Color hintLight = Color(0xFF9E9E9E);
  static const Color hintDark = Color(0xFF7D7D7D);

  // Blue for text / highlights
  static const Color blueLight = Color(0xFF1E88E5); // light mode blue
  static const Color blueDark = Color(0xFF90CAF9);  // dark mode blue

  // Document Blue
  static const Color docBlueLight = Color(0xFF1E4B82); // Light mode
  static const Color docBlueDark = Color(0xFF3D7BFF);  // Dark mode

  // States
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color disabled = Color(0xFFBDBDBD);
}

/// 🧩 Extension for context-based easy usage
extension AppColorsExt on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Brand
  Color get primary => AppColor.primary;

  // Backgrounds
  Color get background =>
      isDark ? AppColor.darkBackground : AppColor.lightBackground;

  // Surface
  Color get surface =>
      isDark ? AppColor.darkSurface : AppColor.lightSurface;

  // Borders
  Color get border =>
      isDark ? AppColor.borderDark : AppColor.borderLight;

  // Dividers
  Color get divider =>
      isDark ? AppColor.dividerDark : AppColor.dividerLight;

  // Text
  Color get textPrimary =>
      isDark ? AppColor.textPrimaryDark : AppColor.textPrimaryLight;

  // Tertiary Text
  Color get textThird => isDark ? AppColor.textThirdDark : AppColor.textThirdLight;

  Color get textSecondary => isDark ? AppColor.textSecondaryDark : AppColor.textSecondaryLight;

  // Hint Text
  Color get hintTextColor =>
      isDark ? AppColor.hintDark : AppColor.hintLight;

  // TextField fill
  Color get textFieldFill =>
      isDark ? AppColor.darkSurface : AppColor.lightSurface;

  // Popup / Card
  Color get popupBackground => surface;

  // Grays
  Color get greyLight => isDark ? AppColor.greyDark : AppColor.greyLight;
  Color get greyLightest => isDark ? AppColor.greyDark : AppColor.greyLightest;
  Color get greyMedium => AppColor.grey;
  Color get greyDark => isDark ? AppColor.greyLight : AppColor.greyDark;

  // State colors
  Color get error => AppColor.error;
  Color get success => AppColor.success;
  Color get warning => AppColor.warning;

  Color get blue => isDark ? AppColor.blueDark : AppColor.blueLight;

  Color get docBlue => isDark ? AppColor.docBlueDark : AppColor.docBlueLight;

  Color get disabled =>
      isDark ? AppColor.disabledDark : AppColor.disabledLight;
  // Aliases
  Color get black => isDark ? AppColor.white : AppColor.black;
  Color get white => isDark ? AppColor.black : AppColor.white;
}




