import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String authorId;
  final String category;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.authorId,
    this.category = 'Novels',
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> json) {
    final rawCategory = json['category'] as String?;
    return ProductModel(
      id: id,
      title: json['title'] as String? ?? 'Untitled Product',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? '',
      authorId: json['authorId'] as String? ?? '',
      category: (rawCategory != null && rawCategory.isNotEmpty)
          ? rawCategory
          : 'Novels',
    );
  }

  factory ProductModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ProductModel.fromMap(doc.id, data);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'authorId': authorId,
      'category': category,
    };
  }
}
