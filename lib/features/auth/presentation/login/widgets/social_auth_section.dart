import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/components/buttons/social_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDark ? Colors.white24 : AppColors.grey200,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:16.w),
              child: Text(
                'Or with',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white70 : AppColors.grey400,
                    ),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark ? Colors.white24 : AppColors.grey200,
              ),
            ),
          ],
        ),
        const Gap(AppSpacing.xl),
        SocialButton(
          text: googleText,
          icon: SvgPicture.asset(
            AppAssets.googleLogoSVG,
            height: 20,
            width: 20,
          ),
          onPressed: () {},
          borderRadius: 40.r,
        ),
        const Gap(AppSpacing.sm),
        SocialButton(
          text: appleText,
          icon: Icon(
            Icons.apple,
            color: isDark ? Colors.white : AppColors.grey900,
            size: 24,
          ),
          onPressed: () {},
          borderRadius: 40.r,
        ),
      ],
    );
  }
}