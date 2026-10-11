import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
}
