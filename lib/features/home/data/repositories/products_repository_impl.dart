import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';
import '../models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<ProductModel>> getProductsStream({String? category}) {
    return remoteDataSource.getProductsStream(category: category);
  }

  @override
  Stream<List<ProductModel>> getProductsByAuthorIdStream(String authorId) {
    return remoteDataSource.getProductsByAuthorIdStream(authorId);
  }
}
