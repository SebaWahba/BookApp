class AddressEntity {
  final String id;
  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String addressType; // 'home' or 'office'

  const AddressEntity({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    required this.addressType,
  });

  AddressEntity copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? formattedAddress,
    String? addressType,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      addressType: addressType ?? this.addressType,
    );
  }
}
