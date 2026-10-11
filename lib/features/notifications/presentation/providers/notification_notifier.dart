import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/usecases/usecase.dart';
import 'notification_providers.dart';
import 'notification_state.dart';

final notificationProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(
  NotificationNotifier.new,
);

class NotificationNotifier extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    // Kick off the first load as soon as the provider is first read.
    Future.microtask(fetchNotifications);
    return const NotificationState(isLoading: true);
  }

  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref.read(getNotificationsUseCaseProvider)(
      const NoParams(),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (notifications) => state = state.copyWith(
        isLoading: false,
        notifications: notifications,
        clearError: true,
      ),
    );
  }

  /// Pull-to-refresh: keeps the current list on screen while reloading.
  Future<void> refresh() => fetchNotifications();
}
