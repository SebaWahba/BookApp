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
AsyncNotifierProvider<HomeController, List<BookModel>>(HomeController.new);