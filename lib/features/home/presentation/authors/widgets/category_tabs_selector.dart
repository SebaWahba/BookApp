import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import '../providers/authors_providers.dart';

class CategoryTabsSelector extends ConsumerWidget {
  const CategoryTabsSelector({super.key});

  static const List<String> authorCategories = [
    'All',
    'Poets',
    'Playwrights',
    'Novelists',
    'Journalists',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryKey = ref.watch(selectedCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 44.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: authorCategories.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          final category = authorCategories[index];
          final isSelected = category == selectedCategoryKey;

          return GestureDetector(
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).setCategory(category);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      category,
                      style: (isSelected
                              ? context.type.bodyMediumBold
                              : context.type.bodyMediumMedium)
                          .copyWith(
                        color: isSelected
                            ? (isDark ? Colors.white : context.colors.title)
                            : (isDark ? Colors.grey[400] : context.colors.body),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (isSelected)
                      Container(
                        height: 2.h,
                        width: 18.w,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white : context.colors.title,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}