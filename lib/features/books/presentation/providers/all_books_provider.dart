import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/books/data/repositories/books_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllBooksState {
  const AllBooksState({
    required this.books,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<BookModel> books;
  final bool hasMore;
  final bool isLoadingMore;

  AllBooksState copyWith({
    List<BookModel>? books,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return AllBooksState(
      books: books ?? this.books,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class AllBooksController extends AsyncNotifier<AllBooksState> {
  static const _query = 'bestseller';
  static const _pageSize = 40;

  @override
  Future<AllBooksState> build() => _fetchFirstPage();

  Future<AllBooksState> _fetchFirstPage() async {
    final repository = ref.read(booksRepositoryProvider);
    final result = await repository.getBooks(
      query: _query,
      maxResults: _pageSize,
    );

    return result.fold(
      (failure) => throw failure,
      (books) =>
          AllBooksState(books: books, hasMore: books.length == _pageSize),
    );
  }

  Future<Object?> refresh() async {
    final result = await AsyncValue.guard(_fetchFirstPage);
    state = result;
    return result.hasError ? result.error : null;
  }

  Future<Object?> loadMore() async {
    if (state is! AsyncData<AllBooksState>) {
      return null;
    }

    final currentState = (state as AsyncData<AllBooksState>).value;
    if (!currentState.hasMore || currentState.isLoadingMore) return null;

    state = AsyncData(currentState.copyWith(isLoadingMore: true));
    final repository = ref.read(booksRepositoryProvider);
    final result = await repository.getBooks(
      query: _query,
      startIndex: currentState.books.length,
      maxResults: _pageSize,
    );

    return result.fold(
      (failure) {
        state = AsyncData(currentState);
        return failure;
      },
      (nextBooks) {
        state = AsyncData(
          AllBooksState(
            books: [...currentState.books, ...nextBooks],
            hasMore: nextBooks.length == _pageSize,
          ),
        );
        return null;
      },
    );
  }
}

final allBooksControllerProvider =
    AsyncNotifierProvider<AllBooksController, AllBooksState>(
      AllBooksController.new,
    );
