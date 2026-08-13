import '../entities/order_entity.dart';

abstract class OrderHistoryRepository {
  Stream<List<OrderEntity>> getOrdersStream();
}