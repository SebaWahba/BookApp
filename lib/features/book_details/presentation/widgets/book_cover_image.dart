import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/themes/app_colors.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';

class BookCoverImage extends ConsumerWidget {
  final String coverUrl;

  const BookCoverImage({super.key, required this.coverUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: coverUrl.isEmpty
            ? Container(
                width: 237,
                height: 313,
                color: isDark ? Colors.grey[850] : AppColors.grey200,
                child: Icon(
                  Icons.book,
                  size: 64,
                  color: isDark ? Colors.white70 : AppColors.grey500,
                ),
              )
            : Image.network(
                coverUrl,
                width: 237,
                height: 313,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 237,
                  height: 313,
                  color: isDark ? Colors.grey[850] : AppColors.grey200,
                  child: Icon(
                    Icons.book,
                    size: 64,
                    color: isDark ? Colors.white70 : AppColors.grey500,
                  ),
                ),
              ),
      ),
    );
  }
}
