import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';

class BookReviewSection extends ConsumerWidget {
  final double rating;

  const BookReviewSection({super.key, required this.rating});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.review,
          style: AppTextStyles.h5.copyWith(
            color: isDark ? Colors.white : null,
          ),
        ),
        const Gap(8),
        Row(
          children: [
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.star_rounded,
                  size: 20,
                  color: index < rating.round()
                      ? AppColors.yellow
                      : (isDark ? Colors.grey[700] : AppColors.grey800),
                ),
              ),
            ),
            const Gap(8),
            Text(
              "(${rating.toStringAsFixed(1)})",
              style: AppTextStyles.bodyMediumMedium.copyWith(
                color: isDark ? Colors.white70 : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}