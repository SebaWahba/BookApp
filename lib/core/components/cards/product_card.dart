import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/home/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: double.infinity,
                child: product.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(color: AppColors.grey100),
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.grey200,
                          child: const Icon(
                            Icons.book,
                            size: 40,
                            color: AppColors.grey400,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.grey200,
                        child: const Icon(
                          Icons.book,
                          size: 40,
                          color: AppColors.grey400,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          Text(
            product.title,
            style: AppTextStyles.bodyMediumBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMediumBold.copyWith(
              color: AppColors.primary500,
            ),
          ),
        ],
      ),
    );
  }
}
