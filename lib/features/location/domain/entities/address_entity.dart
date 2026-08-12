class AddressEntity {
  const AddressEntity({
    required this.id,
    required this.address,
    required this.addressType,
  });

  final String id;
  final String address;
  final String addressType;

  AddressEntity copyWith({
    String? id,
    String? address,
    String? addressType,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      address: address ?? this.address,
      addressType: addressType ?? this.addressType,
    );
  }
}
