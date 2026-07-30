import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/onbaording/presentation/models/onbaording_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../auth/presentation/providers/theme_provider.dart';

class OnboardingPageContent extends ConsumerWidget {
  final OnbaordingModel model;

  const OnboardingPageContent({required this.model, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        children: [
          Expanded(child: SvgPicture.asset(model.imagePath)),
          const SizedBox(height: AppSpacing.md),
          Text(
            model.title,
            style: AppTextStyles.h3.copyWith(
              color: isDark ? Colors.white : null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            model.description,
            style: AppTextStyles.bodyLargeRegular.copyWith(
              color: isDark ? Colors.white70 : AppColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}