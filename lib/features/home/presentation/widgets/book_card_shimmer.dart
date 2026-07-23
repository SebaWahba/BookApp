import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/themes/app_colors.dart';

class BookCardShimmer extends StatelessWidget {
  const BookCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey100,
      highlightColor: AppColors.grey50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 127,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 14,
            color: AppColors.grey100,
          ),
          const SizedBox(height: 4),
          Container(
            width: 70,
            height: 12,
            color: AppColors.grey100,
          ),
        ],
      ),
    );
  }
}