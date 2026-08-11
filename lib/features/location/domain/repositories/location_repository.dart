import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../entities/address_entity.dart';

typedef LocationPosition = ({double latitude, double longitude});

abstract class LocationRepository {
  Future<Either<Failure, bool>> checkAndRequestPermission();
  Future<Either<Failure, LocationPosition>> getCurrentLocation();
  Future<Either<Failure, String>> reverseGeocode(double lat, double lng);
  Future<Either<Failure, void>> saveAddress(AddressEntity address);
}
