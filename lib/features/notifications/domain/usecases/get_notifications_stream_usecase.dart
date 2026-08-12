import '../entities/notification_order_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsStreamUseCase {
  final NotificationsRepository repository;
  GetNotificationsStreamUseCase(this.repository);

  Stream<List<NotificationOrderEntity>> call() {
    return repository.getOrdersStream();
  }
}