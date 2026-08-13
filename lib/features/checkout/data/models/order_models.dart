import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.items,
    required super.subtotal,
    required super.shipping,
    required super.total,
    required super.paymentMethod,
    required super.dateTime,
    required super.deliveryTime,
    required super.address,
    required super.status,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    return OrderModel(
      id: docId,
      items: map['items'] as List<dynamic>? ?? [],
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
      shipping: (map['shipping'] ?? 2.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? 'KNET',
      dateTime: map['dateTime'] ?? '',
      deliveryTime: (map['deliveryTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      address: map['address'] ?? '',
      status: map['status'] ?? 'On the way',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items,
      'subtotal': subtotal,
      'shipping': shipping,
      'total': total,
      'paymentMethod': paymentMethod,
      'dateTime': dateTime,
      'deliveryTime': Timestamp.fromDate(deliveryTime),
      'address': address,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}