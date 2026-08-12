import '../entities/notification_order_entity.dart';

abstract class NotificationsRepository {
  Stream<List<NotificationOrderEntity>> getOrdersStream();
  Future<void> cancelOrder(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
}