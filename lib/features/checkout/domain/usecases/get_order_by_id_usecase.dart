import '../entities/order_entity.dart';
import '../repositories/order_repositories.dart';

class GetOrderByIdUseCase {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  Future<OrderEntity> call(String orderId) async {
    return await repository.getOrderById(orderId);
  }
}