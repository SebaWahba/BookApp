import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Stream<List<ProductModel>> getProductsStream({String? category});
  Stream<List<ProductModel>> getProductsByAuthorIdStream(String authorId);
}
