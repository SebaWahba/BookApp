import 'package:flutter/material.dart';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import '../widgets/category_filter_tabs.dart';
import '../widgets/category_header.dart';
import '../widgets/category_products_grid.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.white,
      appBar: const CategoryHeader(),
      body: const SafeArea(
        child: Column(
          children: [
            SizedBox(height: AppSpacing.xs),
            CategoryFilterTabs(),
            SizedBox(height: AppSpacing.sm),
            Expanded(
              child: CategoryProductsGrid(),
            ),
          ],
        ),
      ),
    );
  }
}