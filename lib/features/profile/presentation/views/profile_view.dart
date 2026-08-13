import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/responsive/app_breakpoints.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/profile/presentation/widgets/profile_header.dart';
import 'package:bookapp/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:bookapp/features/profile/presentation/widgets/theme_toggle_tile.dart';
import 'package:bookapp/l10n/app_localizations.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet = MediaQuery.sizeOf(context).width >= AppBreakpoints.mobile;
    final maxContentWidth = isTablet ? 800.0 : double.infinity;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(color: context.colors.divider),
                  const ProfileHeader(),
                  Divider(color: context.colors.divider),
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
                          onTap: () => context.push(AppRoutes.location),
                        ),
                        Gap(AppSpacing.xxxl.h),
                        ProfileMenuItem(
                          icon: Icons.local_fire_department_rounded,
                          title: l10n.offersAndPromosTitle,
                          onTap: () => context.push(AppRoutes.offers),
                        ),
                        Gap(AppSpacing.xxxl.h),
                        ProfileMenuItem(
                          icon: Icons.favorite,
                          title: l10n.yourFavoritesTitle,
                          onTap: () => context.push(AppRoutes.myFavorite),
                        ),
                        Gap(AppSpacing.xxxl.h),
                        ProfileMenuItem(
                          icon: Icons.receipt_long,
                          title: l10n.orderHistoryTitle,
                          onTap: () => context.push(AppRoutes.orderHistory),
                        ),
                        Gap(AppSpacing.xxxl.h),
                        ProfileMenuItem(
                          icon: CupertinoIcons.chat_bubble_2_fill,
                          title: l10n.helpCenterTitle,
                          onTap: () => context.push(AppRoutes.helpCenter),
                        ),
                        Gap(AppSpacing.xxxl.h),
                        const ThemeToggleTile(),
                        Gap(AppSpacing.xxxl.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}