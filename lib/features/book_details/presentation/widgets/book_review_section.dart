import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

import '../../../../core/theme/extensions/theme_ext.dart';
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
        Text(
          l10n.review,
          style: context.type.h5.copyWith(color: context.colors.title),
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
                      ? context.colors.warning
                      : context.colors.divider,
                ),
              ),
            ),
            const Gap(8),
            Text(
              "(${rating.toStringAsFixed(1)})",
              style: context.type.bodyMediumMedium.copyWith(color: context.colors.body),
            ),
          ],
        ),
      ],
    );
  }
}