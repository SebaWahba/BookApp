import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';

class SignUpFooter extends ConsumerWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Column(
      children: [
        const Gap(AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.alreadyHaveAccount,
              style: AppTextStyles.bodyMediumRegular.copyWith(
                color: isDark ? Colors.white70 : AppColors.grey500,
              ),
            ),
            InkWell(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.login);
                }
              },
              child: Text(
                l10n.signInLink,
                style: AppTextStyles.bodyMediumSemiBold.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        ),
        const Gap(AppSpacing.xxxl),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              l10n.termsAgreement,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmallRegular.copyWith(
                color: isDark ? Colors.white60 : AppColors.grey400,
                height: 1.4,
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}