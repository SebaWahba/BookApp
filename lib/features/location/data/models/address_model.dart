import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.address,
    required super.addressType,
  });

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      address: entity.address,
      addressType: entity.addressType,
    );
  }

  factory AddressModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final addressType = (data['addressType'] as String? ?? doc.id)
        .toLowerCase();

    return AddressModel(
      id: data['id'] as String? ?? addressType,
      address: data['address'] as String? ?? '',
      addressType: addressType,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'address': address,
      'addressType': addressType,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
