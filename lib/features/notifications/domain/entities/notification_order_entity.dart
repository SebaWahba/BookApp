class NotificationOrderEntity {
  final String id;
  final List<dynamic> items;
  final String status;
  final DateTime? deliveryTime;
  final DateTime? createdAt;

  const NotificationOrderEntity({
    required this.id,
    required this.items,
    required this.status,
    this.deliveryTime,
    this.createdAt,
  });
}