import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/home/presentation/widgets/book_card.dart';
import 'package:bookapp/features/home/presentation/widgets/book_card_shimmer.dart';
import 'package:flutter/material.dart';

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
          return const Center(child: CircularProgressIndicator());
        }

        return Align(
          alignment: Alignment.topCenter,
          child: BookCard(book: books[index]),
        );
      },
    );
  }
}
