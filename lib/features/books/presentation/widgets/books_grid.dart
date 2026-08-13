import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/extensions/theme_ext.dart';
import '../../../books/data/models/book_model.dart';
import '../../../home/presentation/widgets/book_card.dart';
import '../../../home/presentation/widgets/book_card_shimmer.dart';

class BooksGrid extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final itemCount = isLoading
        ? 6
        : books.length + (isLoadingMore ? 1 : 0);

    // Was hardcoded crossAxisCount: 2 with a fixed-width BookCard (127.0,
    // unscaled) inside it — same bug class as the old Authors grid: on
    // tablet you got 2 tiny cards floating in huge empty cells instead of
    // more/larger cards filling the space. LayoutBuilder + a real column
    // count fixes that; BookCard's own width is unbounded per-cell below.
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth ~/ 150).clamp(2, 5);
        return GridView.builder(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.xl),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
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
                  color: context.colors.primary,
                ),
              );
            }

            // width: null lets BookCard fill its grid cell instead of
            // staying pinned at its 127.0 default — so cards actually
            // grow on tablet instead of floating small in a big cell.
            return Align(
              alignment: Alignment.topCenter,
              child: BookCard(book: books[index], width: null),
            );
          },
        );
      },
    );
  }
}