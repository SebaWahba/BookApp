import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../entities/author_entity.dart';

abstract class AuthorsRepository {
  Future<Either<Failure, List<AuthorEntity>>> getAuthors();
}
