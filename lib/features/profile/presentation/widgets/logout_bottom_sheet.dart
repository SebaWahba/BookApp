import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/buttons/secondary_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:bookapp/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LogoutBottomSheet extends ConsumerWidget {
  const LogoutBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding.w,
        vertical: AppSpacing.xxl.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Gap(AppSpacing.xl.h),
          Text(
            l10n.logoutConfirmTitle,
            style: AppTextStyles.h5,
            textAlign: TextAlign.center,
          ),
          Gap(AppSpacing.xxxl.h),
          Column(
            children: [
              PrimaryButton(
                text: l10n.logoutButton,
                onPressed: () async {
                  final router = GoRouter.of(context);
                  final navigator = Navigator.of(context);

                  // Sign out before closing the sheet. authProvider is
                  // autoDispose, so popping first would drop this widget's ref,
                  // dispose the notifier mid-request, and make its state write
                  // throw.
                  await ref.read(authProvider.notifier).signOut();

                  navigator.pop();
                  router.go(AppRoutes.login);
                },
                verticalPadding: 14.h,
              ),
              Gap(AppSpacing.md.h),
              SecondaryButton(
                text: l10n.cancelButton,
                onPressed: () => Navigator.pop(context),
                verticalPadding: 14.h,
              ),
            ],
          ),
          Gap(MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
