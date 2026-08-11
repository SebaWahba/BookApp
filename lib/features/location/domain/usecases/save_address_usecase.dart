import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../entities/address_entity.dart';
import '../repositories/location_repository.dart';

class SaveAddressUseCase {
  final LocationRepository repository;

  SaveAddressUseCase(this.repository);

  Future<Either<Failure, void>> call(AddressEntity address) async {
    return await repository.saveAddress(address);
  }
}
