import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ThemeModeStore {
  Future<ThemeMode?> read();
  Future<void> write(ThemeMode mode);
}

class PrefsThemeModeStore implements ThemeModeStore {
  const PrefsThemeModeStore({this.key = 'theme_mode'});

  final String key;

  @override
  Future<ThemeMode?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(key);
    if (index == null || index < 0 || index >= ThemeMode.values.length) {
      return null;
    }
    return ThemeMode.values[index];
  }

  @override
  Future<void> write(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, mode.index);
  }
}

class InMemoryThemeModeStore implements ThemeModeStore {
  InMemoryThemeModeStore([this._mode]);

  ThemeMode? _mode;

  @override
  Future<ThemeMode?> read() async => _mode;

  @override
  Future<void> write(ThemeMode mode) async => _mode = mode;
}