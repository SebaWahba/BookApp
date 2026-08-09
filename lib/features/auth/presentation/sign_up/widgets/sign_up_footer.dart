import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:go_router/go_router.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const Gap(AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.alreadyHaveAccount,
              style: context.type.bodyMediumRegular.copyWith(color: context.colors.body),
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
                style: context.type.bodyMediumSemiBold.copyWith(color: context.colors.primary),
              ),
            ),
          ],
        ),
        const Gap(AppSpacing.xxxl),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.termsAgreement,
              textAlign: TextAlign.center,
              style: context.type.bodySmallRegular.copyWith(
                color: context.colors.hint,
                height: 1.4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
