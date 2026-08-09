import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/my_favorite/presentation/providers/favorites_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookHeaderSection extends ConsumerStatefulWidget {
  final BookModel book;

  const BookHeaderSection({super.key, required this.book});

  @override
  ConsumerState<BookHeaderSection> createState() => _BookHeaderSectionState();
}

class _BookHeaderSectionState extends ConsumerState<BookHeaderSection> {
  @override
  Widget build(BuildContext context) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;
    final isFavoriteAsync = ref.watch(isBookFavoriteProvider(widget.book.id));
    final isFavorite = isFavoriteAsync.when(
      data: (value) => value,
      loading: () => false,
      error: (_, _) => false,
    );
    final favoriteAction = ref.watch(favoriteActionsControllerProvider);
    final isUpdating = favoriteAction.isLoading;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.book.title,
            style: AppTextStyles.h4.copyWith(
              color: isDark ? Colors.white : null,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Gap(16),
        GestureDetector(
          onTap: isUpdating
              ? null
              : () {
                  ref
                      .read(favoriteActionsControllerProvider.notifier)
                      .toggle(widget.book);
                },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: isFavorite
                ? SvgPicture.asset(
                    AppAssets.favIconSvg,
                    key: const ValueKey<bool>(true),
                    width: 28,
                    height: 28,
                  )
                : Icon(
                    Icons.favorite_border,
                    key: const ValueKey<bool>(false),
                    color: AppColors.primary600,
                    size: 28,
                  ),
          ),
        ),
      ],
    );
  }
}
