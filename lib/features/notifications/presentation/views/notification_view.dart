import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/notifications/domain/entities/notification_entity.dart';
import 'package:bookapp/features/notifications/presentation/providers/notification_notifier.dart';
import 'package:bookapp/features/notifications/presentation/providers/notification_state.dart';
import 'package:bookapp/features/notifications/presentation/widgets/delivery_notification_tile.dart';
import 'package:bookapp/features/notifications/presentation/widgets/empty_state_widget.dart';
import 'package:bookapp/features/notifications/presentation/widgets/promo_notification_tile.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.title),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: Text(
          'Notification',
          style: context.type.h5.copyWith(color: context.colors.title),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationProvider.notifier).refresh(),
        child: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationState state) {
    if (state.isLoading && state.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.isEmpty) {
      return CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: Text(
                  state.errorMessage!,
                  style: context.type.bodyLargeMedium.copyWith(
                    color: context.colors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (state.isEmpty) {
      // Show EmptyStateWidget and make it scrollable so refresh indicator works
      return const CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateWidget(),
          ),
        ],
      );
    }

    final groupedNotifications = state.groupedNotifications;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final keys = groupedNotifications.keys.toList();
                final groupKey = keys[index];
                final groupList = groupedNotifications[groupKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupKey,
                      style: context.type.h5.copyWith(
                        color: context.colors.title,
                      ),
                    ),
                    const Gap(AppSpacing.md),
                    ...groupList.map((notification) {
                      if (notification.type == NotificationType.delivery) {
                        return DeliveryNotificationTile(
                          notification: notification,
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            context.push(
                              AppRoutes.promotionDetail,
                              extra: notification,
                            );
                          },
                          child: PromoNotificationTile(
                            notification: notification,
                          ),
                        );
                      }
                    }),
                    const Gap(AppSpacing.xl),
                  ],
                );
              },
              childCount: groupedNotifications.keys.length,
            ),
          ),
        ),
      ],
    );
  }
}
