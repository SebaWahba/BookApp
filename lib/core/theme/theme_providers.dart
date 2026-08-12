import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';
import 'theme_mode_store.dart';

final Provider<AppTheme> lightThemeProvider =
Provider<AppTheme>((Ref ref) => AppTheme.light());

final Provider<AppTheme> darkThemeProvider =
Provider<AppTheme>((Ref ref) => AppTheme.dark());

final Provider<ThemeData> lightThemeDataProvider = Provider<ThemeData>(
      (Ref ref) => ref.watch(lightThemeProvider).toThemeData(Brightness.light),
);

final Provider<ThemeData> darkThemeDataProvider = Provider<ThemeData>(
      (Ref ref) => ref.watch(darkThemeProvider).toThemeData(Brightness.dark),
);

final Provider<ThemeModeStore> themeModeStoreProvider =
Provider<ThemeModeStore>((Ref ref) => const PrefsThemeModeStore());

final Provider<ThemeMode> initialThemeModeProvider =
Provider<ThemeMode>((Ref ref) => ThemeMode.system);

final NotifierProvider<ThemeModeController, ThemeMode> themeModeProvider =
NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  bool _chosen = false;

  @override
  ThemeMode build() {
    _chosen = false;
    unawaited(_restore(ref));
    return ref.watch(initialThemeModeProvider);
  }

  Future<void> _restore(Ref ref) async {
    final ThemeModeStore store = ref.read(themeModeStoreProvider);
    final ThemeMode? saved = await store.read();
    if (!ref.mounted || _chosen || saved == null) return;
    state = saved;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _chosen = true;
    final ThemeModeStore store = ref.read(themeModeStoreProvider);
    if (mode != state) state = mode;
    await store.write(mode);
  }

  Future<void> toggle({required Brightness platformBrightness}) {
    final bool isDark = switch (state) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };
    return setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}