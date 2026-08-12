import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/core/components/buttons/social_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/core/utils/snackbar_utils.dart';
import 'package:bookapp/features/auth/presentation/providers/auth_notifier.dart';

class SocialAuthSection extends ConsumerWidget {
  final String googleText;
  final String appleText;

  const SocialAuthSection({
    required this.googleText,
    required this.appleText,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: context.colors.divider)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or with',
                style: context.type.bodySmallRegular.copyWith(color: context.colors.hint),
              ),
            ),
            Expanded(child: Divider(color: context.colors.divider)),
          ],
        ),
        const Gap(AppSpacing.xl),
        // Google Sign In Button
        SocialButton(
          text: googleText,
          icon: SvgPicture.asset(
            AppAssets.googleLogoSVG,
            width: 20,
            height: 20,
          ),
          onPressed: () async {
            await ref.read(authProvider.notifier).signInWithGoogle();
            if (ref.read(authProvider).isSuccess && context.mounted) {
              context.go(AppRoutes.home);
            }
          },
          borderRadius: 40,
        ),
        const Gap(AppSpacing.sm),
        // Apple Sign In Button (Coming Soon with Green SnackBar)
        SocialButton(
          text: appleText,
          icon: Icon(
            Icons.apple,
            color: context.colors.title,
            size: 24,
          ),
          onPressed: () {
            SnackbarUtils.showSuccess(
              context,
              ' Sign in with Apple is coming soon! ',
            );
          },
          borderRadius: 40,
        ),
      ],
    );
  }
}