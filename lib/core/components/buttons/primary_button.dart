import 'package:flutter/material.dart';

import '../../../config/themes/app_colors.dart';
import '../../../config/themes/app_text_styles.dart';

/// full width pill button so wrap it in a width constrained parent (padding/SizedBox)
class PrimaryButton extends StatelessWidget {
  static const buttonColor = AppColors.primary500;
  static const textColor = AppColors.white;
  final String text;
  final VoidCallback? onPressed;

  /// added as 12.0 for the 48 px in all, override in case 56 px with 16.0
  final double verticalPadding;

  /// Controls the rounded corners of the button.
  /// Defaults to 40.0 for a pill-like look.
  final double borderRadius;

  /// Optional minimum height to customize the button size.
  /// If null, the current default size is preserved.
  final double? minHeight;

  const PrimaryButton({
    required this.text,
    this.onPressed,
    super.key,
    this.verticalPadding = 12.0,
    this.borderRadius = 40.0,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: isDisabled ? buttonColor.withValues(alpha: 0.5) : buttonColor,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight ?? 48.0),
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            alignment: Alignment.center,
            child: Text(
              text,
              style: AppTextStyles.h6.copyWith(
                color: isDisabled
                    ? textColor.withValues(alpha: 0.5)
                    : textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
