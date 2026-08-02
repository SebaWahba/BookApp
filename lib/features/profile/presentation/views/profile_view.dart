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
import 'package:go_router/go_router.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle, style: AppTextStyles.h4)),

      body: Column(
        children: [
          const Divider(color: AppColors.grey200),
          const ProfileHeader(),
          const Divider(color: AppColors.grey200),
          const Gap(AppSpacing.lg),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.person,
                    title: l10n.myAccountTitle,
                    onTap: () => context.push(AppRoutes.myAccount),
                  ),
                  const Gap(AppSpacing.xxxl),
                  ProfileMenuItem(
                    icon: Icons.location_on,
                    title: l10n.addressTitle,
                    // onTap:() => ,
                  ),
                  const Gap(AppSpacing.xxxl),
                  ProfileMenuItem(
                    icon: Icons.local_fire_department_rounded,
                    title: l10n.offersAndPromosTitle,
                    // onTap:() => ,
                  ),
                  const Gap(AppSpacing.xxxl),
                  ProfileMenuItem(
                    icon: Icons.favorite,
                    title: l10n.yourFavoritesTitle,
                    // onTap:() => ,
                  ),
                  const Gap(AppSpacing.xxxl),
                  ProfileMenuItem(
                    icon: Icons.receipt_long,
                    title: l10n.orderHistoryTitle,
                    // onTap:() => ,
                  ),
                  const Gap(AppSpacing.xxxl),
                  ProfileMenuItem(
                    icon: CupertinoIcons.chat_bubble_2_fill,
                    title: l10n.helpCenterTitle,
                    // onTap:() => ,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
