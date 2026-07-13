import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_spacing.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/features/onbaording/presentation/models/onbaording_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnbaordingModel model;

  const OnboardingPageContent({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        children: [
          SvgPicture.asset(
            model.imagePath,
            width: AppSizing.onboardingImageSize,
            height: AppSizing.onboardingImageSize,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            model.title,
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            model.description,
            style: AppTextStyles.bodyLargeRegular.copyWith(
              color: AppColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
