import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/address_entity.dart';
import '../repositories/location_repository.dart';

class SaveAddressUseCase {
  const SaveAddressUseCase(this.repository);

  final LocationRepository repository;

  Future<Either<Failure, void>> call(AddressEntity address) {
    return repository.saveAddress(address);
  }
}
