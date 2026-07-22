import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.h5,
        ),
        GestureDetector(
          onTap: onSeeAllTap,
          child: Text(
            l10n.seeAll,
            style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.primary500),
          ),
        ),
      ],
    );
  }
}