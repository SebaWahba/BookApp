import 'package:flutter/material.dart';
import '../../config/themes/app_text_styles.dart';
import '../../config/themes/app_colors.dart';

class SkipButton extends StatelessWidget {
  static const textColor = AppColors.primary500;
  final VoidCallback onPressed;
  final String text = 'Skip';

  const SkipButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(text, style: AppTextStyles.bodyMediumMedium.copyWith(color: textColor)),
    );
  }
}