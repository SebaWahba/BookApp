import '../../data/models/product_model.dart';

abstract class ProductsRepository {
  Stream<List<ProductModel>> getProductsStream({String? category});
  Stream<List<ProductModel>> getProductsByAuthorIdStream(String authorId);
}
