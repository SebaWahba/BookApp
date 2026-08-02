import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/auth/presentation/login/widgets/sign_in_form.dart';
import 'package:bookapp/features/auth/presentation/login/widgets/sign_in_header.dart';
import 'package:bookapp/features/auth/presentation/login/widgets/social_auth_section.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';

class SignInView extends ConsumerStatefulWidget {
  const SignInView({super.key});

  @override
  ConsumerState<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme(!isDark);
            },
          ),
        ],
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
              SignInHeader(
                title: l10n.signInTitle,
                subtitle: l10n.signInSubtitle,
              ),
              const SignInForm(),
              const Gap(AppSpacing.xl),
              SocialAuthSection(
                googleText: l10n.signInWithGoogle,
                appleText: l10n.signInWithApple,
              ),
              const Gap(AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}