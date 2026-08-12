import 'package:flutter/material.dart';

import '../../config/themes/app_colors.dart';

@immutable
class AppInputTheme extends ThemeExtension<AppInputTheme> {
  const AppInputTheme({
    required this.fill,
    required this.hint,
    required this.borderDefault,
    required this.borderFocused,
    required this.cursor,
  });

  factory AppInputTheme.light() => const AppInputTheme(
    fill: AppColors.grey50,
    hint: AppColors.grey400,
    borderDefault: AppColors.grey50,
    borderFocused: AppColors.primary500,
    cursor: AppColors.primary500,
  );

  factory AppInputTheme.dark() => const AppInputTheme(
    fill: AppColors.grey800,
    hint: AppColors.grey500,
    borderDefault: AppColors.grey800,
    borderFocused: AppColors.primary400,
    cursor: AppColors.primary400,
  );

  final Color fill;
  final Color hint;
  final Color borderDefault;
  final Color borderFocused;
  final Color cursor;

  @override
  AppInputTheme copyWith({
    Color? fill,
    Color? hint,
    Color? borderDefault,
    Color? borderFocused,
    Color? cursor,
  }) {
    return AppInputTheme(
      fill: fill ?? this.fill,
      hint: hint ?? this.hint,
      borderDefault: borderDefault ?? this.borderDefault,
      borderFocused: borderFocused ?? this.borderFocused,
      cursor: cursor ?? this.cursor,
    );
  }

  @override
  AppInputTheme lerp(covariant AppInputTheme? other, double t) {
    if (other == null) return this;
    return AppInputTheme(
      fill: Color.lerp(fill, other.fill, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderFocused: Color.lerp(borderFocused, other.borderFocused, t)!,
      cursor: Color.lerp(cursor, other.cursor, t)!,
    );
  }
}