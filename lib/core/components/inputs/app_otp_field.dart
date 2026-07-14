import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AppOtpField extends StatelessWidget {
  const AppOtpField({
    super.key,
    required this.controller,
    required this.onCompleted,
    this.onChanged,
    this.length = 4,
    this.enabled = true,
  });

  final PinInputController controller;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final int length;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return MaterialPinField(
      length: length,
      pinController: controller,
      enabled: enabled,
      onChanged: onChanged,
      onCompleted: onCompleted,
      theme: MaterialPinTheme(
        shape: MaterialPinShape.outlined,

        cellSize: const Size(52, 52),
        spacing: AppSpacing.md,
        borderRadius: BorderRadius.circular(AppSpacing.sm),

        borderWidth: 1.5,
        focusedBorderWidth: 2.0,
        borderColor: AppColors.primary500,
        focusedBorderColor: AppColors.primary500,
        filledBorderColor: AppColors.primary500,
        errorColor: AppColors.red,

        // Fill
        fillColor: AppColors.grey50,
        focusedFillColor: AppColors.grey50,
        filledFillColor: AppColors.grey50,

        // Text
        textStyle: AppTextStyles.h3,
        // textGradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
        obscuringCharacter: '●',

        // Cursor
        showCursor: true,
        cursorColor: AppColors.primary500,
        cursorWidth: 2,
        animateCursor: true,

        // Animation
        entryAnimation: MaterialPinAnimation.scale,
        animationDuration: Duration(milliseconds: 150),
        animationCurve: Curves.easeOut,

        // Error
        enableErrorShake: true,
        errorAnimationDuration: Duration(milliseconds: 500),
      ),
    );
  }
}
