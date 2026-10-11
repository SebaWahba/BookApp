import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:go_router/go_router.dart';

import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/notifications/domain/entities/notification_entity.dart';

class PromotionDetailView extends StatelessWidget {
  final NotificationEntity notification;

  const PromotionDetailView({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isPromo = notification.type == NotificationType.promotion;
    final title = isPromo ? 'Promotion' : 'Information';

    final banner = notification.bannerImage;
    final hasBanner = banner != null && banner.isNotEmpty;

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
            }
          },
        ),
        title: Text(
          title,
          style: context.type.h5.copyWith(color: context.colors.title),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasBanner) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: banner,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: 200,
                      color: context.colors.surfaceAlt,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: 200,
                      color: context.colors.surfaceAlt,
                      child: Icon(Icons.broken_image, color: context.colors.hint),
                    ),
                  ),
                ),
                const Gap(AppSpacing.xl),
              ],
              Text(
                notification.title,
                style: context.type.h4.copyWith(color: context.colors.title),
              ),
              const Gap(AppSpacing.md),
              Text(
                notification.body,
                style: context.type.bodyLargeRegular.copyWith(
                  color: context.colors.body,
                  height: 1.5,
                ),
              ),
              if (isPromo) ...[
                const Gap(AppSpacing.xxxl),
                PrimaryButton(
                  text: 'Order Now',
                  onPressed: () {
                    // Action for order now
                  },
                ),
                const Gap(AppSpacing.xxxl),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
