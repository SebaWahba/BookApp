import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/address_entity.dart';

abstract class LocationRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();
  Future<Either<Failure, void>> saveAddress(AddressEntity address);
}
