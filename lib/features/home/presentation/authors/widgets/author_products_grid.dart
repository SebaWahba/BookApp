import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../config/themes/app_colors.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../providers/authors_providers.dart';
import 'product_card.dart';

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
      loading: () => _buildGridShimmer(),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Text(
          'Failed to load products: $error',
          style: AppTextStyles.bodyMediumRegular.copyWith(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildGridShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.xl,
      ),
      itemCount: 4,
      itemBuilder: (_, _) => Shimmer.fromColors(
        baseColor: AppColors.grey200,
        highlightColor: AppColors.grey100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
