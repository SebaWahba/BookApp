import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import '../providers/category_providers.dart';

class CategoryFilterTabs extends ConsumerWidget {
  const CategoryFilterTabs({super.key});

  static List<({String key, String Function(AppLocalizations l10n) getLabel})>
      get categoryItems => [
            (key: 'All', getLabel: (l10n) => l10n.all),
            (key: 'Novels', getLabel: (l10n) => l10n.novels),
            (key: 'Self Love', getLabel: (l10n) => l10n.selfLove),
            (key: 'Science', getLabel: (l10n) => l10n.science),
            (key: 'Romantic', getLabel: (l10n) => l10n.romantic),
          ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedCategoryKey = ref.watch(selectedCategoryFilterProvider);

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: categoryItems.length,
        itemBuilder: (context, index) {
          final item = categoryItems[index];
          final isSelected = item.key == selectedCategoryKey;
          final displayTitle = item.getLabel(l10n);

          return GestureDetector(
            onTap: () {
              ref
                  .read(selectedCategoryFilterProvider.notifier)
                  .setCategory(item.key);
            },
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.xl),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppColors.grey900 : Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ),
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                displayTitle,
                style: isSelected
                    ? AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey900)
                    : AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey400),
              ),
            ),
          );
        },
      ),
    );
  }
}
