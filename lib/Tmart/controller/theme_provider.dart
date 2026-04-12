import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // Constructor to load the theme when the provider is created
  ThemeProvider() {     //ye isliye ki jab bhi app khole to iss provider ke loading funtion ko call karke dark theme h ya nahi h iski jankari le
    _loadThemeFromPrefs();
  }

  bool _isDarkMode = false;
  // The key to store the theme preference in shared preferences
  static const String _themeKey = 'isDarkMode';

  bool getThemeValue() => _isDarkMode;

  // Method to load the theme from shared preferences
  void _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false; // Default to light mode if not found
    notifyListeners();
  }


  void updateTheme({required bool value})async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
    notifyListeners();
  }
}