import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';

class SignUpHeader extends ConsumerWidget {
  final String title;
  final String subtitle;

  const SignUpHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h3.copyWith(
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: isDark ? Colors.white70 : AppColors.grey500,
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}