import 'package:bookapp/config/routes/app_router.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_password_field.dart';
import 'package:bookapp/core/components/inputs/app_text_field.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/utils/regex_validators.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/success_type.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/verification_contact_type.dart';
import 'package:bookapp/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../l10n/app_localizations.dart';
import 'package:bookapp/core/components/inputs/password_requirements_card.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  l10n.signUpTitle,
                  style:
                      theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ) ??
                      const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.signUpSubtitle,
                  style:
                      theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey500,
                      ) ??
                      const TextStyle(fontSize: 16, color: AppColors.grey500),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _nameController,
                  hintText: l10n.nameHint,
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: AppColors.grey500,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.valNameEmpty;
                    }
                    if (value.trim().split(' ').length < 2) {
                      return l10n.valNameInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _emailController,
                  hintText: l10n.emailHint,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.grey500,
                  ),
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
                  validator: (value) =>
                      RegexValidators.passwordValidator(value),
                ),
                const SizedBox(height: 12),
                PasswordRequirementsCard(
                  hasMinLength: _passwordController.text.length >= 8,
                  hasNumber: _passwordController.text.contains(RegExp(r'[0-9]')),
                  hasLetter: _passwordController.text.contains(RegExp(r'[a-zA-Z]')),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: authState.isLoading ? 'Loading...' : l10n.signUpButton,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.push(
                        AppRoutes.verificationCode,
                        extra: VerificationCodeArgs(
                          contact: _emailController.text.trim(),
                          contactType: VerificationContactType.email,
                          onVerified: () {
                            context.push(
                              AppRoutes.inputPhoneNumber,
                              extra: (String phone) {
                                context.push(
                                  AppRoutes.verificationCode,
                                  extra: VerificationCodeArgs(
                                    contact: phone,
                                    contactType: VerificationContactType.phone,
                                    onVerified: () => context.push(
                                      AppRoutes.success,
                                      extra: SuccessType.verification,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style:
                          theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.grey500,
                          ) ??
                          const TextStyle(color: AppColors.grey500),
                    ),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).go(AppRoutes.login);
                      },
                      child: Text(
                        l10n.signInLink,
                        style:
                            theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary500,
                              fontWeight: FontWeight.bold,
                            ) ??
                            const TextStyle(
                              color: AppColors.primary500,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.termsAgreement,
                      textAlign: TextAlign.center,
                      style:
                          theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.grey400,
                            height: 1.4,
                          ) ??
                          const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey400,
                          ),
                    ),
                  ),
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