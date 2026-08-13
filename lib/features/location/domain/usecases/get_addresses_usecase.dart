import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/address_entity.dart';
import '../repositories/location_repository.dart';

class GetAddressesUseCase {
  const GetAddressesUseCase(this.repository);

  final LocationRepository repository;

  Future<Either<Failure, List<AddressEntity>>> call() {
    return repository.getAddresses();
  }
}
