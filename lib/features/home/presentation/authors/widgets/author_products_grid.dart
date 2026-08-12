import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/cards/product_card.dart';
import 'package:bookapp/core/components/shimmer/product_grid_shimmer.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import '../providers/authors_providers.dart';

class AuthorProductsGrid extends ConsumerWidget {
  final String authorId;

  const AuthorProductsGrid({super.key, required this.authorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(authorProductsProvider(authorId));

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Column(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  size: 48,
                  color: AppColors.grey400,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No products available for this author.',
                  style: AppTextStyles.bodyMediumRegular.copyWith(
                    color: AppColors.grey500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
      loading: () => const ProductGridShimmer(itemCount: 4),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Text(
          'Failed to load products: $error',
          style: AppTextStyles.bodyMediumRegular.copyWith(color: Colors.red),
        ),
      ),
    );
  }
}
