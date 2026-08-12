import 'package:flutter/material.dart';

import '../app_button_theme.dart';
import '../app_color_scheme.dart';
import '../app_input_theme.dart';
import '../app_theme.dart';
import '../app_typography.dart';

extension AppThemeExt on BuildContext {
  AppTheme get appTheme {
    final theme = Theme.of(this).extension<AppTheme>();
    if (theme == null) {
      throw FlutterError(
        'AppTheme is not registered. Build your ThemeData with '
            'AppTheme.light().toThemeData(Brightness.light).',
      );
    }
    return theme;
  }
  AppColorScheme get colors => appTheme.colors;
  AppTypography get type => appTheme.typography;
  AppButtonTheme get buttonTheme => appTheme.buttons;
  AppInputTheme get inputTheme => appTheme.inputs;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}