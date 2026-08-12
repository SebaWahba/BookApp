import 'package:flutter/material.dart';

import '../../config/themes/app_colors.dart';

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.primary,
    required this.onPrimary,
    required this.primarySurface,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.title,
    required this.body,
    required this.hint,
    required this.stroke,
    required this.divider,
    required this.disabled,
    required this.onDisabled,
    required this.success,
    required this.warning,
    required this.error,
  });

  factory AppColorScheme.light() => const AppColorScheme(
    primary: AppColors.primary500,
    onPrimary: AppColors.white,
    primarySurface: AppColors.primary50,
    background: AppColors.grey50,
    surface: AppColors.white,
    surfaceAlt: AppColors.grey100,
    title: AppColors.grey900,
    body: AppColors.grey500,
    hint: AppColors.grey400,
    stroke: AppColors.grey300,
    divider: AppColors.grey200,
    disabled: AppColors.grey200,
    onDisabled: AppColors.grey400,
    success: AppColors.green,
    warning: AppColors.yellow,
    error: AppColors.red,
  );

  factory AppColorScheme.dark() => const AppColorScheme(
    primary: AppColors.primary400,
    onPrimary: AppColors.grey900,
    primarySurface: AppColors.primary900,
    background: AppColors.grey900,
    surface: AppColors.grey800,
    surfaceAlt: AppColors.grey700,
    title: AppColors.white,
    body: AppColors.grey300,
    hint: AppColors.grey400,
    stroke: AppColors.grey600,
    divider: AppColors.grey700,
    disabled: AppColors.grey700,
    onDisabled: AppColors.grey500,
    success: AppColors.green,
    warning: AppColors.yellow,
    error: AppColors.red,
  );

  final Color primary;
  final Color onPrimary;
  final Color primarySurface;

  final Color background;
  final Color surface;
  final Color surfaceAlt;

  final Color title;
  final Color body;
  final Color hint;

  final Color stroke;
  final Color divider;

  final Color disabled;
  final Color onDisabled;

  final Color success;
  final Color warning;
  final Color error;

  @override
  AppColorScheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primarySurface,
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? title,
    Color? body,
    Color? hint,
    Color? stroke,
    Color? divider,
    Color? disabled,
    Color? onDisabled,
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return AppColorScheme(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primarySurface: primarySurface ?? this.primarySurface,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      title: title ?? this.title,
      body: body ?? this.body,
      hint: hint ?? this.hint,
      stroke: stroke ?? this.stroke,
      divider: divider ?? this.divider,
      disabled: disabled ?? this.disabled,
      onDisabled: onDisabled ?? this.onDisabled,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  /// Without this, switching light <-> dark snaps instead of animating.
  @override
  AppColorScheme lerp(covariant AppColorScheme? other, double t) {
    if (other == null) return this;
    return AppColorScheme(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primarySurface: Color.lerp(primarySurface, other.primarySurface, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      title: Color.lerp(title, other.title, t)!,
      body: Color.lerp(body, other.body, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      onDisabled: Color.lerp(onDisabled, other.onDisabled, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}