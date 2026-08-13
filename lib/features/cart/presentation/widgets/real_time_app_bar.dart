import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';

class RealTimeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RealTimeAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.h4.copyWith(color: AppColors.grey900)),
      centerTitle: true,
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
        onPressed: () => context.pop(),
      ),
      actions: [
        // زرار الجرس شغال وكليكابل 100%
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, color: AppColors.grey900),
          onPressed: () {
            context.push(AppRoutes.notifications);
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.grey900),
          onPressed: () {
            context.push(AppRoutes.cart);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}