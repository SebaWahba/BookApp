import '../entities/CartItemEntity.dart';

abstract class CartRepository {
  Stream<List<CartItemEntity>> getCartItems();
  Future<void> removeFromCart(String docId);
}