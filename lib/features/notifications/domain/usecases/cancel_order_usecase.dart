import '../repositories/notifications_repository.dart';

class CancelOrderUseCase {
  final NotificationsRepository repository;
  CancelOrderUseCase(this.repository);

  Future<void> call(String orderId) async {
    return await repository.cancelOrder(orderId);
  }
}