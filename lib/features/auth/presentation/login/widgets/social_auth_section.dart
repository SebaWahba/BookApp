import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/components/buttons/social_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/svg.dart';

class SocialAuthSection extends StatelessWidget {
  final String googleText;
  final String appleText;

  const SocialAuthSection({
    required this.googleText,
    required this.appleText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.grey200)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or with',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.grey400),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.grey200)),
          ],
        ),
        const Gap(AppSpacing.xl),
        SocialButton(
          text: googleText,
          icon: SvgPicture.asset(
            AppAssets.googleLogoSVG,
            height: 16,
            width: 16,
          ),
          onPressed: () {},
          borderRadius: 40,
        ),
        const Gap(AppSpacing.sm),
        SocialButton(
          text: appleText,
          icon: const Icon(Icons.apple, color: AppColors.grey900, size: 24),
          onPressed: () {},
          borderRadius: 40,
        ),
      ],
    );
  }
}
