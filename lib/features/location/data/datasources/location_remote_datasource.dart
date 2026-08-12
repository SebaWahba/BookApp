import '../models/address_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<void> saveAddress(AddressModel address);
}
