import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for SharedPreferences
const _themePrefKey = 'app_theme_mode';

/// Theme Controller with persistence
class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themePrefKey);
    if (themeIndex != null) {
      state = ThemeMode.values[themeIndex];
    } else {
      state = ThemeMode.light;
    }
  }

  Future<void> changeTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePrefKey, mode.index);
  }
}

/// Provider
final themeModeProvider =
StateNotifierProvider<ThemeController, ThemeMode>((ref) {
  return ThemeController();
});
