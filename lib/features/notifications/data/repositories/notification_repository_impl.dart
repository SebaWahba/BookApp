import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      return Right(notifications);
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Failure _mapFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return NetworkFailure(
          'No internet connection. Pull down to try again.',
        );
      case 'permission-denied':
      case 'unauthenticated':
        return AuthSessionFailure(
          'You do not have permission to view notifications.',
        );
      case 'not-found':
        return NotFoundFailure('Notifications could not be found.');
      case 'resource-exhausted':
        return RateLimitFailure('Too many requests. Please try again later.');
      default:
        return ServerFailure(e.message ?? 'Failed to load notifications.');
    }
  }
}
