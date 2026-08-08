import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:bookapp/features/auth/presentation/login/widgets/sign_in_form.dart';
import 'package:bookapp/features/auth/presentation/login/widgets/sign_in_header.dart';
import 'package:bookapp/features/auth/presentation/login/widgets/social_auth_section.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';
import 'package:bookapp/features/auth/presentation/providers/auth_notifier.dart';

class SignInView extends ConsumerStatefulWidget {
  const SignInView({super.key});

  @override
  ConsumerState<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  bool _isHandlingError = false;

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
        if (!_isHandlingError) {
          _isHandlingError = true;
          
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          ).closed.then((_) {
            if (mounted) {
              _isHandlingError = false;
            }
          });

          Future.microtask(() {
            ref.read(authProvider.notifier).clearError();
          });
        }
      }

      if (next.isSuccess && (previous?.isSuccess == false)) {
        if (context.mounted) {
          context.go(AppRoutes.home);
        }
      }
    });

    final authState = ref.watch(authProvider);

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
              
              // قسم التواصل الاجتماعي: جوجل يعمل بشكل طبيعي تماماً للـ Login والـ Creation، وأبل يعرض Coming Soon بالنجوم والرسالة الخضراء
              SocialAuthSection(
                googleText: l10n.signInWithGoogle,
                appleText: l10n.signInWithApple,
              ),

              const Gap(AppSpacing.xl),
              if (authState.isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}