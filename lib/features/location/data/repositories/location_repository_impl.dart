import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';
import '../models/address_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl(this.remoteDataSource);

  final LocationRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    try {
      final addresses = await remoteDataSource.getAddresses();
      return Right(addresses);
    } on FirebaseAuthException catch (e) {
      return Left(AuthSessionFailure(e.message ?? 'Authentication required'));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to load addresses'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveAddress(AddressEntity address) async {
    try {
      await remoteDataSource.saveAddress(AddressModel.fromEntity(address));
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthSessionFailure(e.message ?? 'Authentication required'));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to save address'));
    } on ArgumentError catch (e) {
      return Left(ValidationFailure(e.message.toString()));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
