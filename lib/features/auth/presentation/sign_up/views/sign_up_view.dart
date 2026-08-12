import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/auth/presentation/providers/auth_notifier.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';
import 'package:bookapp/features/auth/presentation/sign_up/widgets/sign_up_form.dart';
import 'package:bookapp/features/auth/presentation/sign_up/widgets/sign_up_header.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );

        if (next.errorMessage!.contains('already registered') ||
            next.errorMessage!.contains('already in use')) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (context.mounted) {
              context.go(AppRoutes.login);
            }
          });
        }

        Future.microtask(() {
          ref.read(authProvider.notifier).clearError();
        });
      }

      if (next.isSuccess && (previous?.isSuccess == false)) {
        context.push(AppRoutes.verificationCode);
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
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
              const Gap(AppSpacing.xl),
              const SignUpForm(),
              const Gap(AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
