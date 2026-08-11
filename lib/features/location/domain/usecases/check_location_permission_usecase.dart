import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../repositories/location_repository.dart';

class CheckLocationPermissionUseCase {
  final LocationRepository repository;

  CheckLocationPermissionUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.checkAndRequestPermission();
  }
}
