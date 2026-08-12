import 'package:flutter/material.dart';

import 'app_button_theme.dart';
import 'app_color_scheme.dart';
import 'app_input_theme.dart';
import 'app_typography.dart';

/// Step 5 — one object to rule them all.
///
/// [toThemeData] hands back a fully wired [ThemeData] so app.dart never has
/// to know how the extension is registered. Also bridges into AppBar,
/// TextTheme, and InputDecorationTheme — the Material widgets not directly
/// wrapped by context.colors/context.type — matching what the old
/// config/themes/app_theme.dart did, but sourced from the new governed roles.
@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  const AppTheme({
    required this.colors,
    required this.typography,
    required this.buttons,
    required this.inputs,
  });

  factory AppTheme.light() => AppTheme(
    colors: AppColorScheme.light(),
    typography: AppTypography.regular(),
    buttons: AppButtonTheme.light(),
    inputs: AppInputTheme.light(),
  );

  factory AppTheme.dark() => AppTheme(
    colors: AppColorScheme.dark(),
    typography: AppTypography.regular(),
    buttons: AppButtonTheme.dark(),
    inputs: AppInputTheme.dark(),
  );

  final AppColorScheme colors;
  final AppTypography typography;
  final AppButtonTheme buttons;
  final AppInputTheme inputs;

  ThemeData toThemeData(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: <ThemeExtension<dynamic>>[this],
      scaffoldBackgroundColor: colors.background,
      primaryColor: colors.primary,
      dividerColor: colors.divider,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: brightness,
      ).copyWith(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        surface: colors.surface,
        error: colors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.title),
        titleTextStyle: typography.h4.copyWith(color: colors.title),
      ),
      textTheme: TextTheme(
        headlineLarge: typography.h1,
        headlineMedium: typography.h2,
        headlineSmall: typography.h3,
        bodyLarge: typography.bodyLargeRegular,
        bodyMedium: typography.bodyMediumRegular,
        bodySmall: typography.bodySmallRegular,
      ).apply(
        bodyColor: colors.body,
        displayColor: colors.title,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: typography.bodyMediumRegular.copyWith(color: inputs.hint),
        filled: true,
        fillColor: inputs.fill,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: inputs.borderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: inputs.borderFocused),
        ),
      ),
    );
  }

  @override
  AppTheme copyWith({
    AppColorScheme? colors,
    AppTypography? typography,
    AppButtonTheme? buttons,
    AppInputTheme? inputs,
  }) {
    return AppTheme(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      buttons: buttons ?? this.buttons,
      inputs: inputs ?? this.inputs,
    );
  }

  @override
  AppTheme lerp(covariant AppTheme? other, double t) {
    if (other == null) return this;
    return AppTheme(
      colors: colors.lerp(other.colors, t),
      typography: typography.lerp(other.typography, t),
      buttons: buttons.lerp(other.buttons, t),
      inputs: inputs.lerp(other.inputs, t),
    );
  }
}