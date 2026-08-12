import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_order_entity.dart';

class NotificationOrderModel extends NotificationOrderEntity {
  const NotificationOrderModel({
    required super.id,
    required super.items,
    required super.status,
    super.deliveryTime,
    super.createdAt,
  });

  factory NotificationOrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return NotificationOrderModel(
      id: docId,
      items: map['items'] as List<dynamic>? ?? [],
      status: map['status'] ?? 'Pending',
      deliveryTime: (map['deliveryTime'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}