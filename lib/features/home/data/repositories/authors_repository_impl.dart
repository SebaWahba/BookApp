import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/features/home/domain/entities/author_entity.dart';
import 'package:bookapp/features/home/domain/repositories/authors_repository.dart';
import '../datasources/authors_remote_datasource.dart';
import '../models/author_model.dart';
import '../models/product_model.dart';

class AuthorsRepositoryImpl implements AuthorsRepository {
  final AuthorsRemoteDataSource remoteDataSource;

  AuthorsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<AuthorEntity>>> getAuthors() async {
    try {
      final models = await remoteDataSource.getAuthors();
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<AuthorModel>> getAuthorsStream() {
    return remoteDataSource.getAuthorsStream();
  }

  @override
  Stream<List<ProductModel>> getProductsByAuthorIdStream(String authorId) {
    return remoteDataSource.getProductsByAuthorIdStream(authorId);
  }
}
