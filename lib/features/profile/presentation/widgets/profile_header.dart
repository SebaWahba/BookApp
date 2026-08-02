import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/profile/presentation/providers/profile_controller.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(profileControllerProvider);

    final name = profileAsync.maybeWhen(
      data: (user) => user.name.isNotEmpty ? user.name : 'John Freeman',
      orElse: () => 'John Freeman',
    );
    final email = profileAsync.maybeWhen(
      data: (user) =>
          user.email.isNotEmpty ? user.email : 'john.freeman@gmail.com',
      orElse: () => 'john.freeman@gmail.com',
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 56,
            height: 56,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: AppColors.primary500,
            ),
          ),
          const Gap(AppSpacing.xxl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.h6),
              Text(
                email,
                style: AppTextStyles.bodyMediumRegular.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              l10n.logoutButton,
              style: AppTextStyles.bodyMediumBold.copyWith(
                color: AppColors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
