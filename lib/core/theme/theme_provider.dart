import 'package:algonaid_mobail_app/core/utils/cache/shared_pref.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  static const String _colorKey = 'primaryColorIndex';
  static const String _fontKey = 'fontFamilyIndex';
  
  ThemeMode _themeMode = ThemeMode.system;
  int _colorIndex = 0;
  int _fontIndex = 0;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  int get colorIndex => _colorIndex;
  int get fontIndex => _fontIndex;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final window = WidgetsBinding.instance.window;
      return window.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void _loadTheme() {
    final isDark = CacheHelper.getBool(key: _themeKey);
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }
    _colorIndex = CacheHelper.getInt(key: _colorKey) ?? 0;
    _fontIndex = CacheHelper.getInt(key: _fontKey) ?? 0;
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    CacheHelper.saveData(key: _themeKey, value: isDark);
    notifyListeners();
  }

  void changeColor(int index) {
    _colorIndex = index;
    CacheHelper.saveData(key: _colorKey, value: index);
    notifyListeners();
  }

  void changeFont(int index) {
    _fontIndex = index;
    CacheHelper.saveData(key: _fontKey, value: index);
    notifyListeners();
  }
}

