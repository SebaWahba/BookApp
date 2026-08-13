import '../repositories/order_repositories.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<String> call({
    required List<dynamic> items,
    required double subtotal,
    required double shipping,
    required double total,
    required String paymentMethod,
    required String dateTime,
    required DateTime deliveryTime,
    required String address,
  }) async {
    return await repository.createOrder(
      items: items,
      subtotal: subtotal,
      shipping: shipping,
      total: total,
      paymentMethod: paymentMethod,
      dateTime: dateTime,
      deliveryTime: deliveryTime,
      address: address,
    );
  }
}