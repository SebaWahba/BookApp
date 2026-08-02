import 'package:bookapp/features/auth/presentation/sign_up/widgets/sign_up_footer.dart';
import 'package:bookapp/features/auth/presentation/sign_up/widgets/sign_up_form.dart';
import 'package:bookapp/features/auth/presentation/sign_up/widgets/sign_up_header.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';

class SignUpView extends ConsumerWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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