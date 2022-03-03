import 'package:flutter/material.dart';
import 'package:todo_application/utils/settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsService settingsService = SettingsService();

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  loadSettings() {
    _themeMode = settingsService.themeMode();
    // notifyListeners();
  }

  updateThemeMode(bool isDarkMode) async {
    if (isDarkMode) {
      if (_themeMode == ThemeMode.dark) {
        return;
      }
    }
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await settingsService.updateThemeMode(isDarkMode);
  }
}
