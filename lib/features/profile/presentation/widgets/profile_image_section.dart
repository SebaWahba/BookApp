import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          clipBehavior: Clip.antiAlias,
          child: CircleAvatar(
            backgroundImage: AssetImage(AppAssets.authorJohnFreeman),
            radius: 50,
          ),
        ),
        const Gap(AppSpacing.lg),
        Text(
          l10n.changePicture,
          style: AppTextStyles.bodyLargeSemiBold.copyWith(
            color: AppColors.primary500,
          ),
        ),
      ],
    );
  }
}
