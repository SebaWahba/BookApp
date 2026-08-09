import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/home/presentation/widgets/book_card.dart';
import 'package:bookapp/features/home/presentation/widgets/book_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/theme_provider.dart';

class BooksGrid extends ConsumerWidget {
  const BooksGrid({
    super.key,
    required this.books,
    required this.isLoading,
    required this.isLoadingMore,
    this.controller,
  });

  final List<BookModel> books;
  final bool isLoading;
  final bool isLoadingMore;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    final itemCount = isLoading ? 6 : books.length + (isLoadingMore ? 1 : 0);

    return GridView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.xl,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) {
        if (isLoading) {
          return const Align(
            alignment: Alignment.topCenter,
            child: BookCardShimmer(),
          );
        }

        if (index == books.length) {
          return Center(
            child: CircularProgressIndicator(
              color: isDark ? Colors.white : null,
            ),
          );
        }

        return Align(
          alignment: Alignment.topCenter,
          child: BookCard(book: books[index]),
        );
      },
    );
  }
}
