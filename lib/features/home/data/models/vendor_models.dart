import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    required super.id,
    required super.name,
    required super.imagePath,
    required super.category,
    required super.rating,
  });

  factory VendorModel.fromJson(String id, Map<String, dynamic> json) {
    return VendorModel(
      id: id,
      name: json['name'] ?? '',
      imagePath: json['image'] ?? '',
      category: json['category'] ?? 'All',
      rating: (json['rating'] as num?)?.toInt() ?? 4,
    );
  }
}
