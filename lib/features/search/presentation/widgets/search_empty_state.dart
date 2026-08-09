import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/theme_provider.dart';

class SearchEmptyState extends ConsumerWidget {
  final bool isInitial;

  const SearchEmptyState({super.key, this.isInitial = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : AppColors.primary100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isInitial ? Icons.search_rounded : Icons.menu_book_rounded,
              size: 48,
              color: AppColors.primary400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isInitial ? 'Search for Books' : 'No Books Found',
            style: AppTextStyles.h5.copyWith(
              color: isDark ? Colors.white : AppColors.grey700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isInitial
                ? 'Type a title, author or topic\nto find your next read'
                : 'Try a different keyword\nor check your spelling',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMediumRegular.copyWith(
              color: isDark ? Colors.white70 : AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}
