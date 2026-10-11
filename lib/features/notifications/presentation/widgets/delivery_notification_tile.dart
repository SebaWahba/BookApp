import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/notifications/domain/entities/notification_entity.dart';

class DeliveryNotificationTile extends StatelessWidget {
  const DeliveryNotificationTile({
    super.key,
    required this.notification,
  });

  final NotificationEntity notification;

  Color _getStatusColor(BuildContext context, DeliveryStatus? status) {
    switch (status) {
      case DeliveryStatus.onTheWay:
        return context.colors.primary;
      case DeliveryStatus.delivered:
        return context.colors.success;
      case DeliveryStatus.cancelled:
        return context.colors.error;
      default:
        return context.colors.body;
    }
  }

  String _getStatusText(DeliveryStatus? status) {
    switch (status) {
      case DeliveryStatus.onTheWay:
        return 'On the way';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookImage = notification.bookImage;
    final hasImage = bookImage != null && bookImage.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.stroke),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: hasImage
                ? CachedNetworkImage(
                    imageUrl: bookImage,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 56,
                      height: 56,
                      color: context.colors.surfaceAlt,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 56,
                      height: 56,
                      color: context.colors.surfaceAlt,
                      child: Icon(Icons.book, color: context.colors.hint),
                    ),
                  )
                : Container(
                    width: 56,
                    height: 56,
                    color: context.colors.surfaceAlt,
                    child: Icon(Icons.book, color: context.colors.hint),
                  ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.bookTitle ?? notification.title,
                  style: context.type.bodyLargeSemiBold.copyWith(
                    color: context.colors.title,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      _getStatusText(notification.deliveryStatus),
                      style: context.type.bodyMediumMedium.copyWith(
                        color: _getStatusColor(
                          context,
                          notification.deliveryStatus,
                        ),
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      '•',
                      style: context.type.bodyMediumRegular.copyWith(
                        color: context.colors.hint,
                      ),
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      '${notification.itemsCount ?? 1} items',
                      style: context.type.bodyMediumRegular.copyWith(
                        color: context.colors.body,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
