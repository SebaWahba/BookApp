import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  final Timestamp? updatedAt;

  const AddressModel({
    required super.id,
    required super.latitude,
    required super.longitude,
    required super.formattedAddress,
    required super.addressType,
    this.updatedAt,
  });

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      latitude: entity.latitude,
      longitude: entity.longitude,
      formattedAddress: entity.formattedAddress,
      addressType: entity.addressType,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return AddressModel(
      id: id ?? (json['id'] as String? ?? json['addressType'] as String? ?? ''),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      formattedAddress: json['formattedAddress'] as String? ?? '',
      addressType: json['addressType'] as String? ?? 'home',
      updatedAt: json['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'formattedAddress': formattedAddress,
      'addressType': addressType,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
