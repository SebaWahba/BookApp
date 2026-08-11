import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../repositories/location_repository.dart';

class ReverseGeocodeParams {
  final double latitude;
  final double longitude;

  const ReverseGeocodeParams({
    required this.latitude,
    required this.longitude,
  });
}

class ReverseGeocodeUseCase {
  final LocationRepository repository;

  ReverseGeocodeUseCase(this.repository);

  Future<Either<Failure, String>> call(ReverseGeocodeParams params) async {
    return await repository.reverseGeocode(params.latitude, params.longitude);
  }
}
