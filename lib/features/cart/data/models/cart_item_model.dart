import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  final String id;
  final String title;
  final double price;
  final String thumbnailUrl;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnailUrl,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'thumbnailUrl': thumbnailUrl,
      'quantity': quantity,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }
}