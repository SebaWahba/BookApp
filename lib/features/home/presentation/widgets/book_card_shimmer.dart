import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/extensions/theme_ext.dart';

class BookCardShimmer extends StatelessWidget {
  final double width;

  const BookCardShimmer({super.key, this.width = 127.0});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.surfaceAlt,
      highlightColor: context.colors.surface,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: width,
              height: width * 1.18,
              decoration: BoxDecoration(
                color: context.colors.surfaceAlt,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: width * 0.8,
              height: 14,
              color: context.colors.surfaceAlt,
            ),
            const SizedBox(height: 4),
            Container(
              width: width * 0.4,
              height: 12,
              color: context.colors.surfaceAlt,
            ),
          ],
        ),
      ),
    );
  }
}