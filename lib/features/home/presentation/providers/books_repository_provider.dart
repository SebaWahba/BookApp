import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/fake_books_repository_impl.dart';
import '../../domain/repositories/books_repository.dart';

final booksRepositoryProvider = Provider<BooksRepository>((ref) {
  return FakeBooksRepositoryImpl();
});