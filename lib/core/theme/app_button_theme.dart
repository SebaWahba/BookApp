import 'package:flutter/material.dart';

import '../../config/themes/app_colors.dart';

@immutable
class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  const AppButtonTheme({
    required this.primaryDefault,
    required this.primaryDisabled,
    required this.primaryLabel,
    required this.primaryLabelDisabled,
    required this.secondaryDefault,
    required this.secondaryLabel,
  });

  factory AppButtonTheme.light() => AppButtonTheme(
    primaryDefault: AppColors.primary500,
    primaryDisabled: AppColors.primary500.withValues(alpha: 0.5),
    primaryLabel: AppColors.white,
    primaryLabelDisabled: AppColors.white.withValues(alpha: 0.5),
    secondaryDefault: AppColors.primary50,
    secondaryLabel: AppColors.primary500,
  );

  factory AppButtonTheme.dark() => AppButtonTheme(
    primaryDefault: AppColors.primary500,
    primaryDisabled: AppColors.primary500.withValues(alpha: 0.5),
    primaryLabel: AppColors.white,
    primaryLabelDisabled: AppColors.white.withValues(alpha: 0.5),
    secondaryDefault: AppColors.primary900,
    secondaryLabel: AppColors.primary300,
  );

  final Color primaryDefault;
  final Color primaryDisabled;
  final Color primaryLabel;
  final Color primaryLabelDisabled;

  final Color secondaryDefault;
  final Color secondaryLabel;

  @override
  AppButtonTheme copyWith({
    Color? primaryDefault,
    Color? primaryDisabled,
    Color? primaryLabel,
    Color? primaryLabelDisabled,
    Color? secondaryDefault,
    Color? secondaryLabel,
  }) {
    return AppButtonTheme(
      primaryDefault: primaryDefault ?? this.primaryDefault,
      primaryDisabled: primaryDisabled ?? this.primaryDisabled,
      primaryLabel: primaryLabel ?? this.primaryLabel,
      primaryLabelDisabled: primaryLabelDisabled ?? this.primaryLabelDisabled,
      secondaryDefault: secondaryDefault ?? this.secondaryDefault,
      secondaryLabel: secondaryLabel ?? this.secondaryLabel,
    );
  }

  @override
  AppButtonTheme lerp(covariant AppButtonTheme? other, double t) {
    if (other == null) return this;
    return AppButtonTheme(
      primaryDefault: Color.lerp(primaryDefault, other.primaryDefault, t)!,
      primaryDisabled: Color.lerp(primaryDisabled, other.primaryDisabled, t)!,
      primaryLabel: Color.lerp(primaryLabel, other.primaryLabel, t)!,
      primaryLabelDisabled: Color.lerp(primaryLabelDisabled, other.primaryLabelDisabled, t)!,
      secondaryDefault: Color.lerp(secondaryDefault, other.secondaryDefault, t)!,
      secondaryLabel: Color.lerp(secondaryLabel, other.secondaryLabel, t)!,
    );
  }
}