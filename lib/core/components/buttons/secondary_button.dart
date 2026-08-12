import 'package:flutter/material.dart';

import '../../theme/extensions/theme_ext.dart';

/// full width secondary button so wrap it in a width constrained parent (padding/SizedBox)
class SecondaryButton extends StatelessWidget {
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
        color: context.colors.primarySurface,
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
              style: context.type.h6.copyWith(color: context.colors.primary),
            ),
          ),
        ),
      ),
    );
  }
}