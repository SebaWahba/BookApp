import 'package:flutter/material.dart';

import '../../../config/themes/app_colors.dart';
import '../../../config/themes/app_text_styles.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;
  final double borderRadius;
  final double? minHeight;

  const SocialButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    super.key,
    this.borderRadius = 40.0,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            height: minHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey200),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 12),
                Text(
                  text,
                  style: AppTextStyles.bodyLargeSemiBold.copyWith(
                    color: AppColors.grey900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
