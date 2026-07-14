import 'package:flutter/material.dart';
import '../../../config/themes/app_text_styles.dart';
import '../../../config/themes/app_colors.dart';

/// full width secondary sign in button so wrap it in a width constrained parent (padding/SizedBox)
class SecondaryButton extends StatelessWidget {
  static const buttonColor = AppColors.primary50;
  static const textColor = AppColors.primary500;
  final VoidCallback onPressed;
  const SecondaryButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            color: buttonColor,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: Text(
              'Sign in',
              style: AppTextStyles.h6.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}