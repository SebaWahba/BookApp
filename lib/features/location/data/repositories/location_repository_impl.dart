import 'package:dartz/dartz.dart';
import 'package:bookapp/core/error/failure.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';
import '../datasources/location_service_datasource.dart';
import '../models/address_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationServiceDataSource serviceDataSource;

  LocationRepositoryImpl({
    required this.remoteDataSource,
    required this.serviceDataSource,
  });

  @override
  Future<Either<Failure, bool>> checkAndRequestPermission() async {
    try {
      final hasPermission = await serviceDataSource.checkAndRequestPermission();
      return Right(hasPermission);
    } catch (e) {
      return Left(UnknownFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, LocationPosition>> getCurrentLocation() async {
    try {
      final position = await serviceDataSource.getCurrentLocation();
      return Right((latitude: position.latitude, longitude: position.longitude));
    } catch (e) {
      return Left(UnknownFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, String>> reverseGeocode(double lat, double lng) async {
    try {
      final address = await serviceDataSource.reverseGeocode(lat, lng);
      return Right(address);
    } catch (e) {
      return Left(UnknownFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> saveAddress(AddressEntity address) async {
    try {
      final model = AddressModel.fromEntity(address);
      await remoteDataSource.saveAddress(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
