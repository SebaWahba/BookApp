import 'package:intl/intl.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationState {
  /// Section header used for deliveries that are still in progress.
  static const String currentSection = 'Current';

  final bool isLoading;
  final String? errorMessage;
  final List<NotificationEntity> notifications;

  const NotificationState({
    this.isLoading = false,
    this.errorMessage,
    this.notifications = const [],
  });

  bool get isEmpty => notifications.isEmpty;

  /// Notifications grouped by section header, preserving the incoming order
  /// (newest first).
  ///
  /// Deliveries that are still on the way go under "Current"; everything else
  /// is grouped by month, e.g. "October 2021", "September 2021".
  Map<String, List<NotificationEntity>> get groupedNotifications {
    final grouped = <String, List<NotificationEntity>>{};
    final monthFormat = DateFormat('MMMM yyyy');

    final current = notifications.where(_isCurrent).toList();
    if (current.isNotEmpty) grouped[currentSection] = current;

    for (final notification in notifications) {
      if (_isCurrent(notification)) continue;
      final key = monthFormat.format(notification.createdAt);
      (grouped[key] ??= []).add(notification);
    }
    return grouped;
  }

  static bool _isCurrent(NotificationEntity n) =>
      n.type == NotificationType.delivery &&
      n.deliveryStatus == DeliveryStatus.onTheWay;

  NotificationState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<NotificationEntity>? notifications,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      notifications: notifications ?? this.notifications,
    );
  }
}
