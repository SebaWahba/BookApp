import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

class SignInHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SignInHeader({required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h3),
        const Gap(AppSpacing.lg),
        Text(
          subtitle,
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: AppColors.grey500,
          ),
        ),
        const Gap(AppSpacing.lg),
      ],
    );
  }
}
