import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<Either<Failure, LocationPosition>> call() async {
    return await repository.getCurrentLocation();
  }
}
