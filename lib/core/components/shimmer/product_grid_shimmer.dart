import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/constants/app_spacing.dart';

class ProductGridShimmer extends StatelessWidget {
  final int itemCount;
  final double childAspectRatio;

  const ProductGridShimmer({
    super.key,
    this.itemCount = 4,
    this.childAspectRatio = 0.65,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.xl,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => Shimmer.fromColors(
        baseColor: AppColors.grey200,
        highlightColor: AppColors.grey100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(width: 100, height: 14, color: Colors.white),
            const SizedBox(height: 4),
            Container(width: 60, height: 12, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
