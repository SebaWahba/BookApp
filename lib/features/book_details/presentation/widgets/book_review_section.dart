import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class BookReviewSection extends StatelessWidget {
  final double rating;

  const BookReviewSection({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.review, style: AppTextStyles.h5),
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
                      : AppColors.grey800,
                ),
              ),
            ),
            const Gap(8),
            Text(
              "(${rating.toStringAsFixed(1)})",
              style: AppTextStyles.bodyMediumMedium,
            ),
          ],
        ),
      ],
    );
  }
}
