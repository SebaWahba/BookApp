import 'package:bookapp/features/book_details/domain/usecases/get_book_details_usecase.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/books/data/repositories/books_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getBookDetailsUseCaseProvider = Provider<GetBookDetailsUseCase>((ref) {
  return GetBookDetailsUseCase(ref.watch(booksRepositoryProvider));
});

final bookDetailsProvider = FutureProvider.family<BookModel, String>((
  ref,
  volumeId,
) async {
  final result = await ref.watch(getBookDetailsUseCaseProvider).call(volumeId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (book) => book,
  );
});
