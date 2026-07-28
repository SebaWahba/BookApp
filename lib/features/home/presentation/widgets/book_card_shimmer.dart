import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../auth/presentation/providers/theme_provider.dart';

class BookCardShimmer extends ConsumerWidget {
  final double width;

  const BookCardShimmer({
    super.key,
    this.width = 127.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : AppColors.grey100,
      highlightColor: isDark ? Colors.grey[700]! : AppColors.grey50,
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
                color: isDark ? Colors.grey[800]! : AppColors.grey100,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: width * 0.8,
              height: 14,
              color: isDark ? Colors.grey[800]! : AppColors.grey100,
            ),
            const SizedBox(height: 4),
            Container(
              width: width * 0.4,
              height: 12,
              color: isDark ? Colors.grey[800]! : AppColors.grey100,
            ),
          ],
        ),
      ),
    );
  }
}