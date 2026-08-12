import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/CartItemEntity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.title,
    required super.price,
    required super.thumbnailUrl,
    required super.quantity,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map, String docId) {
    return CartItemModel(
      id: docId,
      title: map['title'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'thumbnailUrl': thumbnailUrl,
      'quantity': quantity,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }
}                   