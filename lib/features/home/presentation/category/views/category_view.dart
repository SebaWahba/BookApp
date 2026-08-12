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
    return const Scaffold(
      backgroundColor: AppColors.white,
      appBar: CategoryHeader(),
      body: SafeArea(
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
