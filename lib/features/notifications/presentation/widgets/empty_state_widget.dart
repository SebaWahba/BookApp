import 'package:flutter/material.dart';

import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 140,
              color: context.colors.stroke,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'There is no notifications',
              style: context.type.h5.copyWith(color: context.colors.title),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
