import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/usecases/cancel_order_usecase.dart';
import '../../domain/usecases/get_notifications_stream_usecase.dart';
import '../../domain/entities/notification_order_entity.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepositoryImpl();
});

final getNotificationsStreamUseCaseProvider = Provider<GetNotificationsStreamUseCase>((ref) {
  final repository = ref.read(notificationsRepositoryProvider);
  return GetNotificationsStreamUseCase(repository);
});

final cancelOrderUseCaseProvider = Provider<CancelOrderUseCase>((ref) {
  final repository = ref.read(notificationsRepositoryProvider);
  return CancelOrderUseCase(repository);
});

final notificationsStreamProvider = StreamProvider<List<NotificationOrderEntity>>((ref) {
  final useCase = ref.read(getNotificationsStreamUseCaseProvider);
  return useCase();
});