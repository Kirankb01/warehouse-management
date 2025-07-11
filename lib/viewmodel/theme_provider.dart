import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/app_settings.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> loadThemeFromHive() async {
    final box = Hive.box<AppSettings>('app_settings');
    final settings = box.get('settings_key');
    _isDarkMode = settings?.isDarkMode ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    final box = Hive.box<AppSettings>('app_settings');
    final settings = box.get('settings_key');
    if (settings != null) {
      settings.isDarkMode = value;
      await settings.save();
    }
  }

  void resetToDefault() {
    _isDarkMode = false;
    notifyListeners();
  }
}

