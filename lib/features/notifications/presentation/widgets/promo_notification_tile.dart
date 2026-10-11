import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:intl/intl.dart';

import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/notifications/domain/entities/notification_entity.dart';

class PromoNotificationTile extends StatelessWidget {
  const PromoNotificationTile({
    super.key,
    required this.notification,
  });

  final NotificationEntity notification;

  String get _typeText {
    if (notification.type == NotificationType.promotion) return 'Promotion';
    if (notification.type == NotificationType.information) return 'Information';
    return '';
  }

  Color _getTypeColor(BuildContext context) {
    if (notification.type == NotificationType.promotion) {
      return context.colors.primary;
    }
    if (notification.type == NotificationType.information) {
      return Colors.blue;
    }
    return context.colors.title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.stroke),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _typeText,
                style: context.type.bodyLargeSemiBold.copyWith(
                  color: _getTypeColor(context),
                ),
              ),
              Text(
                DateFormat('MMM d • HH.mm').format(notification.createdAt),
                style: context.type.bodyMediumRegular.copyWith(
                  color: context.colors.hint,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.xs),
          Text(
            notification.title,
            style: context.type.bodyMediumSemiBold.copyWith(
              color: context.colors.title,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(AppSpacing.xs),
          Text(
            notification.body,
            style: context.type.bodyMediumRegular.copyWith(
              color: context.colors.title,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
