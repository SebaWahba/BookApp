import 'package:flutter/material.dart';
import '../../config/themes/app_text_styles.dart';
import '../../config/themes/app_colors.dart';

/// full width pill button so wrap it in a width constrained parent (padding/SizedBox)
class PrimaryButton extends StatelessWidget {
  static const buttonColor = AppColors.primary500;
  static const textColor = AppColors.white;
  final String text;
  final VoidCallback onPressed;
  /// added as 12.0 for the 48 px in all, override in case 56 px with 16.0
  final double verticalPadding;
  const PrimaryButton({required this.text, required this.onPressed, super.key, this.verticalPadding = 12.0});

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
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            alignment: Alignment.center,
            child: Text(
              text,
              style: AppTextStyles.h6.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}