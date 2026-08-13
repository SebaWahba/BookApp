import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../books/data/models/book_model.dart';
import '../../domain/usecases/search_books_usecase.dart';
import '../../../books/data/repositories/books_repository_impl.dart';

final searchBooksUseCaseProvider = Provider<SearchBooksUseCase>((ref) {
  return SearchBooksUseCase(ref.watch(booksRepositoryProvider));
});

class HomeController extends AsyncNotifier<List<BookModel>> {
  @override
  Future<List<BookModel>> build() async {
    return _fetchBooks();
  }

  Future<List<BookModel>> _fetchBooks() async {
    final useCase = ref.read(searchBooksUseCaseProvider);
    final result = await useCase('bestseller');
    return result.fold((failure) => throw failure, (books) => books);
  }

  /// Refreshes the book list. If books are already showing and the refresh
  /// fails, the old list stays visible (true seamless refresh) instead of
  /// being replaced by the error state. The error is returned to the caller
  /// so the UI can show a lightweight notification without losing content.
  Future<Object?> refresh() async {
    final previousData = state is AsyncData<List<BookModel>>
        ? (state as AsyncData<List<BookModel>>).value
        : null;
    final result = await AsyncValue.guard(() => _fetchBooks());

    if (result.hasError && previousData != null) {
      state = AsyncData(previousData);
      return result.error;
    }

    state = result;
    return result.hasError ? result.error : null;
  }
}

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, List<BookModel>>(HomeController.new);
