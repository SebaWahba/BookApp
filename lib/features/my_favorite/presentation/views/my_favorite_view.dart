import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/book_details/presentation/views/menu_detail_view.dart';
import 'package:bookapp/features/my_favorite/presentation/providers/favorites_providers.dart';
import 'package:bookapp/features/my_favorite/presentation/widgets/favorite_book_card.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyFavoriteView extends ConsumerWidget {
  const MyFavoriteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final favoritesAsync = ref.watch(favoriteBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yourFavoritesTitle, style: AppTextStyles.h4),
      ),
      body: favoritesAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return const _EmptyFavoritesState();
          }

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              return FavoriteBookCard(
                book: book,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.90,
                        child: MenuDetailView(bookModel: book),
                      );
                    },
                  );
                },
                onRemovePressed: () => ref
                    .read(favoriteActionsControllerProvider.notifier)
                    .remove(book.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMediumRegular.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyFavoritesState extends StatelessWidget {
  const _EmptyFavoritesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.primary100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 48,
                color: AppColors.primary400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Favorites Yet',
              style: AppTextStyles.h5.copyWith(color: AppColors.grey700),
            ),
            const SizedBox(height: 8),
            Text(
              'Books you favorite will appear here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMediumRegular.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
