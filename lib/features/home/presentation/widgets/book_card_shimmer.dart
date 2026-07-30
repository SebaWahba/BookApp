import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../auth/presentation/providers/theme_provider.dart';

class BookCardShimmer extends ConsumerWidget {
  const BookCardShimmer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : AppColors.grey100,
      highlightColor: isDark ? Colors.grey[700]! : AppColors.grey50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 127,
            height: 150,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800]! : AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 14,
            color: isDark ? Colors.grey[800]! : AppColors.grey100,
          ),
          const SizedBox(height: 4),
          Container(
            width: 50,
            height: 12,
            color: isDark ? Colors.grey[800]! : AppColors.grey100,
          ),
        ],
      ),
    );
  }
}