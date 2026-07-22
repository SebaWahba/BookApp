import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/books_repository.dart';

class FakeBooksRepositoryImpl implements BooksRepository {
  @override
  Future<Either<Failure, List<Book>>> searchBooks(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final books = [
      const Book(
        id: '1',
        title: 'The Kite Runner',
        authors: ['Khaled Hosseini'],
        thumbnail: null,
        averageRating: 4.5,
        description: 'A story of friendship and redemption.',
      ),
      const Book(
        id: '2',
        title: 'The Subtle Art of Not Giving a F*ck',
        authors: ['Mark Manson'],
        thumbnail: null,
        averageRating: 4.2,
        description: 'A counterintuitive approach to living a good life.',
      ),
      const Book(
        id: '3',
        title: 'The Art of War',
        authors: ['Sun Tzu'],
        thumbnail: null,
        averageRating: 4.7,
        description: 'An ancient Chinese military treatise.',
      ),
    ];

    return Right(books);
  }

  @override
  Future<Either<Failure, Book>> getBookById(String id) {
    throw UnimplementedError('getBookById is not part of Task B scope');
  }
}