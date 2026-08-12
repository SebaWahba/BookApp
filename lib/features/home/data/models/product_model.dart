import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String authorId;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.authorId,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ProductModel(
      id: doc.id,
      title: data['title'] as String? ?? 'Untitled Product',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'authorId': authorId,
    };
  }
}
