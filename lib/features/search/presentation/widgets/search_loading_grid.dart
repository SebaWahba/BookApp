import 'package:bookapp/features/home/presentation/widgets/book_card_shimmer.dart';
import 'package:bookapp/features/search/presentation/widgets/search_books_grid.dart';
import 'package:flutter/material.dart';

class SearchLoadingGrid extends StatelessWidget {
  const SearchLoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchBooksGrid(
      itemCount: 6,
      itemBuilder: (_, _) => const BookCardShimmer(),
    );
  }
}
