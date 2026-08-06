import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_password_field.dart';
import 'package:bookapp/core/components/inputs/app_text_field.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/services/biometric_service.dart';
import 'package:bookapp/core/utils/regex_validators.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bookapp/features/auth/presentation/providers/auth_notifier.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final BiometricService _biometricService = BiometricService();
  bool _isBiometricSupported = false;
  bool _isBiometricLoading = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    final available = await _biometricService.isBiometricAvailable();
    if (mounted) {
      setState(() {
        _isBiometricSupported = available;
      });
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() {
      _isBiometricLoading = true;
    });

    final authenticated = await _biometricService.authenticate();

    if (mounted) {
      if (authenticated) {
        // Retrieve and restore saved user session / token from AuthNotifier
        final success = await ref
            .read(authProvider.notifier)
            .signInWithBiometrics();

        if (mounted) {
          setState(() {
            _isBiometricLoading = false;
          });

          if (success) {
            GoRouter.of(context).go(AppRoutes.home);
          }
        }
      } else {
        setState(() {
          _isBiometricLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.emailLabel,
            style: AppTextStyles.bodyMediumMedium.copyWith(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const Gap(AppSpacing.sm),
          AppTextField(
            controller: _emailController,
            hintText: l10n.emailHint,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return l10n.valEmailEmpty;
              }
              if (!RegexValidators.isEmail(val)) {
                return l10n.valEmailInvalid;
              }
              return null;
            },
          ),
          const Gap(AppSpacing.xl),
          Text(
            l10n.passwordLabel,
            style: AppTextStyles.bodyMediumMedium.copyWith(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const Gap(AppSpacing.sm),
          AppPasswordField(
            controller: _passwordController,
            hintText: l10n.passwordHint,
            validator: (value) => RegexValidators.passwordValidator(value),
          ),
          const Gap(AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                GoRouter.of(context).push(AppRoutes.forgetPassword);
              },
              child: Text(
                l10n.forgotPassword,
                style: AppTextStyles.bodyMediumSemiBold.copyWith(
                  color: AppColors.primary500,
                ),
              ),
            ),
          ),
          const Gap(AppSpacing.xl),
          PrimaryButton(
            text: authState.isLoading ? l10n.loading : l10n.signInButton,
            onPressed: authState.isLoading || _isBiometricLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      ref.read(authProvider.notifier).clearError();

                      await ref.read(authProvider.notifier).signIn(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                    }
                  },
          ),

          // Render Biometric Authentication Card Button only if device hardware supports it
          if (_isBiometricSupported) ...[
            const Gap(AppSpacing.md),
            Material(
              color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF4F0FF),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: (_isBiometricLoading || authState.isLoading)
                    ? null
                    : _handleBiometricLogin,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary500.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isBiometricLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary500,
                          ),
                        )
                      else ...[
                        const Icon(
                          Icons.fingerprint,
                          size: 26,
                          color: AppColors.primary500,
                        ),
                        const Gap(10),
                        Text(
                          'Login with Biometrics',
                          style: AppTextStyles.bodyMediumSemiBold.copyWith(
                            color: AppColors.primary500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],

          const Gap(AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.dontHaveAccount,
                style: AppTextStyles.bodyMediumRegular.copyWith(
                  color: isDark ? Colors.white70 : AppColors.grey500,
                ),
              ),
              const Gap(4),
              InkWell(
                onTap: () {
                  GoRouter.of(context).push(AppRoutes.signUp);
                },
                child: Text(
                  l10n.signUpLink,
                  style: AppTextStyles.bodyMediumSemiBold.copyWith(
                    color: AppColors.primary500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}