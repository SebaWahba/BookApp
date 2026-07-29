import 'package:flutter/material.dart';

import '../../../config/themes/app_colors.dart';
import '../../../config/themes/app_text_styles.dart';

/// full width secondary button so wrap it in a width constrained parent (padding/SizedBox)
class SecondaryButton extends StatelessWidget {
  static const buttonColor = AppColors.primary50;
  static const textColor = AppColors.primary500;
  final VoidCallback onPressed;
  final String text;

  /// Controls the rounded corners of the button.
  /// Defaults to 40.0 for a pill-like look (matches PrimaryButton).
  final double borderRadius;

  /// added as 12.0 for the 48 px in all, override in case 56 px with 16.0
  final double verticalPadding;

  const SecondaryButton({
    required this.onPressed,
    required this.text,
    super.key,
    this.borderRadius = 40.0,
    this.verticalPadding = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48.0),
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
