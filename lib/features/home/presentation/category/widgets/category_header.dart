import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';

class CategoryHeader extends StatelessWidget implements PreferredSizeWidget {
  const CategoryHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.search, color: AppColors.grey900, size: 24),
        onPressed: () {
          context.push(AppRoutes.search);
        },
      ),
      title: Text(
        'Category',
        style: AppTextStyles.h4,
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: AppColors.grey900,
            size: 24,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications tapped')),
            );
          },
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}
