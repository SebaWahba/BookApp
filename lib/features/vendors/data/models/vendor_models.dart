import 'package:bookapp/features/vendors/domain/entities/vendor_entity.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    required super.id,
    required super.name,
    required super.imagePath,
    required super.category,
    required super.rating,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['vendor_name'] ?? '',
      imagePath: json['image'] ?? json['image_path'] ?? 'assets/images/wattpad.png',
      category: json['category'] ?? 'All',
      rating: (json['rating'] as num?)?.toInt() ?? 4,
    );
  }
}
