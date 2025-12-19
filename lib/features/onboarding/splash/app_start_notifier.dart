import 'package:shared_preferences/shared_preferences.dart';

class AppStartNotifier {
  static const String key = "onboardingCompleted";

  static Future<void> setOnboardDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  static Future<bool> isOnboardDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}
