import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum to represent theme modes more explicitly if needed, though ThemeMode exists
// enum AppThemeMode { light, dark }

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themePrefKey = 'app_theme_mode';

  ThemeCubit(this._prefs) : super(ThemeMode.light) {
    _loadTheme();
  }

  final SharedPreferences _prefs;

  // Load theme from SharedPreferences
  void _loadTheme() {
    final savedTheme = _prefs.getString(_themePrefKey);
    if (savedTheme == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light); // Default to light
    }
  }

  // Toggle theme and save to SharedPreferences
  void toggleTheme() {
    final newThemeMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _prefs.setString(_themePrefKey, newThemeMode == ThemeMode.dark ? 'dark' : 'light');
    emit(newThemeMode);
  }
}

