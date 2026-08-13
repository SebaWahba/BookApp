import '../repositories/CartItem_repo.dart';
import '../entities/CartItemEntity.dart';

class GetCartItemsUseCase {
  final CartRepository repository;
  GetCartItemsUseCase(this.repository);

  Stream<List<CartItemEntity>> call() {
    return repository.getCartItems();
  }
}