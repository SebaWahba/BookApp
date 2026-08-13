import '../entities/order_entity.dart'; // تأكدي من إضافة الـ import ده فوق

abstract class OrderRepository {
  Future<String> createOrder({
    required List<dynamic> items,
    required double subtotal,
    required double shipping,
    required double total,
    required String paymentMethod,
    required String dateTime,
    required DateTime deliveryTime,
    required String address,
  });

  // ضيفي السطر ده هنا:
  Future<OrderEntity> getOrderById(String orderId);
}