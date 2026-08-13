class OrderEntity {
  final String id;
  final List<dynamic> items;
  final double subtotal;
  final double shipping;
  final double total;
  final String paymentMethod;
  final String dateTime;
  final DateTime deliveryTime;
  final String address;
  final String status;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.paymentMethod,
    required this.dateTime,
    required this.deliveryTime,
    required this.address,
    required this.status,
  });
}