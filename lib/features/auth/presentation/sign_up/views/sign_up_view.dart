import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/auth/presentation/sign_up/widgets/sign_up_footer.dart';
import 'package:bookapp/features/auth/presentation/sign_up/widgets/sign_up_form.dart';
import 'package:bookapp/features/auth/presentation/sign_up/widgets/sign_up_header.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.login);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(AppSpacing.lg),
              SignUpHeader(
                title: l10n.signUpTitle,
                subtitle: l10n.signUpSubtitle,
              ),
              const SignUpForm(),
              const SignUpFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
