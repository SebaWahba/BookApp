import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/book.dart';
import '../../domain/usecases/search_books_usecase.dart';
import 'books_repository_provider.dart';

final searchBooksUseCaseProvider = Provider<SearchBooksUseCase>((ref) {
  return SearchBooksUseCase(ref.watch(booksRepositoryProvider));
});

class HomeController extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() async {
    return _fetchBooks();
  }

  Future<List<Book>> _fetchBooks() async {
    final useCase = ref.read(searchBooksUseCaseProvider);
    final result = await useCase('bestseller');

    return result.fold(
          (failure) => throw failure,
          (books) => books,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _fetchBooks());
  }
}

final homeControllerProvider =
AsyncNotifierProvider<HomeController, List<Book>>(HomeController.new);