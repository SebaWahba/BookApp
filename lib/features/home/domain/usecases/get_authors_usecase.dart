import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/core/usecases/usecase.dart';
import '../entities/author_entity.dart';
import '../repositories/authors_repository.dart';

class GetAuthorsUseCase implements UseCase<List<AuthorEntity>, NoParams> {
  final AuthorsRepository repository;
  GetAuthorsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AuthorEntity>>> call(NoParams params) {
    return repository.getAuthors();
  }
}
