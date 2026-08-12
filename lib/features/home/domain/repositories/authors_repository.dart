import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../entities/author_entity.dart';
import '../../data/models/author_model.dart';
import '../../data/models/product_model.dart';

abstract class AuthorsRepository {
  Future<Either<Failure, List<AuthorEntity>>> getAuthors();
  Stream<List<AuthorModel>> getAuthorsStream();
  Stream<List<ProductModel>> getProductsByAuthorIdStream(String authorId);
}
