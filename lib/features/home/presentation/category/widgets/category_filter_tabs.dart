import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import '../providers/category_providers.dart';

class CategoryFilterTabs extends ConsumerWidget {
  final List<String> categories;

  const CategoryFilterTabs({
    super.key,
    this.categories = const [
      'All',
      'Novels',
      'Self Love',
      'Science',
      'Romantic',
    ],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryFilterProvider);

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () {
              ref
                  .read(selectedCategoryFilterProvider.notifier)
                  .setCategory(category);
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
                category,
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
