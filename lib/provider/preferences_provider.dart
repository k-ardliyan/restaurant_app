import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  static const String darkThemeKey = 'DARK_THEME';
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  PreferencesProvider() {
    _getTheme();
  }

  void _getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool(darkThemeKey) ?? false;
    notifyListeners();
  }

  void enableDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(darkThemeKey, value);
    _isDarkTheme = value;
    notifyListeners();
  }
}
