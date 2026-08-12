import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/profile/presentation/widgets/profile_header.dart';
import 'package:bookapp/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle, style: AppTextStyles.h4)),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(color: AppColors.grey200),
            const ProfileHeader(),
            const Divider(color: AppColors.grey200),
            const Gap(AppSpacing.lg),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding.w,
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.person,
                    title: l10n.myAccountTitle,
                    onTap: () => context.push(AppRoutes.myAccount),
                  ),
                  Gap(AppSpacing.xxxl.h),
                  ProfileMenuItem(
                    icon: Icons.location_on,
                    title: l10n.addressTitle,
                    // onTap:() => ,
                  ),
                  Gap(AppSpacing.xxxl.h),
                  ProfileMenuItem(
                    icon: Icons.local_fire_department_rounded,
                    title: l10n.offersAndPromosTitle,
                    // onTap:() => ,
                  ),
                  Gap(AppSpacing.xxxl.h),
                  ProfileMenuItem(
                    icon: Icons.favorite,
                    title: l10n.yourFavoritesTitle,
                    // onTap:() => ,
                  ),
                  Gap(AppSpacing.xxxl.h),
                  ProfileMenuItem(
                    icon: Icons.receipt_long,
                    title: l10n.orderHistoryTitle,
                    // onTap:() => ,
                  ),
                  Gap(AppSpacing.xxxl.h),
                  ProfileMenuItem(
                    icon: CupertinoIcons.chat_bubble_2_fill,
                    title: l10n.helpCenterTitle,
                    // onTap:() => ,
                  ),
                  Gap(AppSpacing.xxxl.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}