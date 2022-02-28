import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_application/constants/constant.dart';

class SettingsService {
  SharedPreferences? sharedPreferences;

  initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<ThemeMode> themeMode() async {
    if (sharedPreferences == null) {
      await initializeSharedPreferences();
    }
    final isDarkMode =
        sharedPreferences!.getBool(ThemeConstants.darkMode) ?? false;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
    // return ThemeMode.system;
  }

  updateThemeMode(bool isDarkMode) async {
    if (sharedPreferences == null) {
      await initializeSharedPreferences();
    }
    await sharedPreferences!.setBool(ThemeConstants.darkMode, isDarkMode);
  }
}
