import 'package:flutter/material.dart';

import '../../../../../config/themes/app_colors.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/constants/app_spacing.dart';

class AuthorsHeaderTitles extends StatelessWidget {
  const AuthorsHeaderTitles({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check the authors',
            style: AppTextStyles.bodySmallRegular.copyWith(
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Authors',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary500,
            ),
          ),
        ],
      ),
    );
  }
}
