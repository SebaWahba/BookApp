import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_password_field.dart';
import 'package:bookapp/core/components/inputs/app_text_field.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/utils/regex_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../l10n/app_localizations.dart';

class SignInView extends ConsumerStatefulWidget {
  const SignInView({super.key});

  @override
  ConsumerState<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  l10n.signInTitle,
                  style:
                  theme.textTheme.headlineLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold) ??
                      const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.signInSubtitle,
                  style:
                  theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey500) ??
                      const TextStyle(fontSize: 16, color: AppColors.grey500),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _emailController,
                  hintText: l10n.emailHint,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.grey500),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.valEmailEmpty;
                    }
                    if (!RegexValidators.isEmail(value)) {
                      return l10n.valEmailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppPasswordField(
                  controller: _passwordController,
                  hintText: l10n.passwordHint,
                  validator: (value) => RegexValidators.passwordValidator(value),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      GoRouter.of(context).push(AppRoutes.forgetPassword);
                    },
                    child: Text(
                      l10n.forgotPassword,
                      style:
                      theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ) ??
                          const TextStyle(color: AppColors.primary500, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: l10n.signInButton,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      GoRouter.of(context).go(AppRoutes.home);
                    }
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.dontHaveAccount,
                      style:
                      theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey500) ??
                          const TextStyle(color: AppColors.grey500),
                    ),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).push(AppRoutes.signUp);
                      },
                      child: Text(
                        l10n.signUpLink,
                        style:
                        theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary500,
                          fontWeight: FontWeight.bold,
                        ) ??
                            const TextStyle(color: AppColors.primary500, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.grey200)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(l10n.orWithDivider, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.grey400)),
                    ),
                    const Expanded(child: Divider(color: AppColors.grey200)),
                  ],
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: AppColors.grey200),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 20,
                    errorBuilder: (c, e, s) => const Icon(Icons.g_mobiledata, color: Colors.red),
                  ),
                  label: Text(
                    l10n.signInWithGoogle,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: AppColors.grey200),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.apple, color: Colors.black, size: 20),
                  label: Text(
                    l10n.signInWithApple,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}