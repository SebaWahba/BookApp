import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/home/presentation/widgets/book_card.dart';
import 'package:bookapp/features/search/presentation/widgets/search_books_grid.dart';
import 'package:flutter/material.dart';

class SearchResultsGrid extends StatelessWidget {
  final List<BookModel> books;

  const SearchResultsGrid({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return SearchBooksGrid(
      itemCount: books.length,
      itemBuilder: (_, index) {
        return BookCard(book: books[index]);
      },
    );
  }
}
