import '../entities/order_entity.dart';
import '../repositories/order_history_repository.dart';

class GetOrderHistoryUseCase {
  final OrderHistoryRepository repository;

  GetOrderHistoryUseCase(this.repository);

  Stream<List<OrderEntity>> call() {
    return repository.getOrdersStream();
  }
}