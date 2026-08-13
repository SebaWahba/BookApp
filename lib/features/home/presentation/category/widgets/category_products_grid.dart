import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/cards/product_card.dart';
import 'package:bookapp/core/components/shimmer/product_grid_shimmer.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import '../providers/category_providers.dart';

class CategoryProductsGrid extends ConsumerWidget {
  const CategoryProductsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(categoryProductsStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: AppColors.grey400,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'No products found in this category',
                    style: AppTextStyles.h4.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sm,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.xl,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(product: product);
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: ProductGridShimmer(itemCount: 6),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            'Error loading category products: $error',
            style: AppTextStyles.bodyMediumRegular.copyWith(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}