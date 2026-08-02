import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bookapp/config/routes/app_router.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_password_field.dart';
import 'package:bookapp/core/components/inputs/app_text_field.dart';
import 'package:bookapp/core/components/inputs/password_requirements_card.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/utils/regex_validators.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/verification_contact_type.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';
import 'package:bookapp/features/auth/presentation/providers/auth_notifier.dart';
import 'package:bookapp/l10n/app_localizations.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name",
            style: AppTextStyles.bodyMediumMedium.copyWith(
              color: isDark ? Colors.white : null,
            ),
          ),
          const Gap(AppSpacing.sm),
          AppTextField(
            controller: _nameController,
            hintText: l10n.nameHint,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.grey500,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return l10n.valNameEmpty;
              if (value.trim().split(' ').length < 2) {
                return l10n.valNameInvalid;
              }
              return null;
            },
          ),
          const Gap(AppSpacing.md),
          Text(
            "Email",
            style: AppTextStyles.bodyMediumMedium.copyWith(
              color: isDark ? Colors.white : null,
            ),
          ),
          const Gap(AppSpacing.sm),
          AppTextField(
            controller: _emailController,
            hintText: l10n.emailHint,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.grey500,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return l10n.valEmailEmpty;
              if (!RegexValidators.isEmail(value)) return l10n.valEmailInvalid;
              return null;
            },
          ),
          const Gap(AppSpacing.md),
          Text(
            "Password",
            style: AppTextStyles.bodyMediumMedium.copyWith(
              color: isDark ? Colors.white : null,
            ),
          ),
          const Gap(AppSpacing.sm),
          AppPasswordField(
            controller: _passwordController,
            hintText: l10n.passwordHint,
            validator: (value) => RegexValidators.passwordValidator(value),
          ),
          const Gap(AppSpacing.sm),
          PasswordRequirementsCard(
            hasMinLength: _passwordController.text.length >= 8,
            hasNumber: _passwordController.text.contains(RegExp(r'[0-9]')),
            hasLetter: _passwordController.text.contains(RegExp(r'[a-zA-Z]')),
          ),
          const Gap(AppSpacing.xxxl),
          PrimaryButton(
            text: authState.isLoading ? l10n.loading : l10n.signUpButton,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  // 1. محاولة التسجيل
                  await ref.read(authProvider.notifier).signUp(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                      );

                  if (!context.mounted) return;

                  // 2. إرسال إيميل التحقق
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null && !user.emailVerified) {
                    await user.sendEmailVerification();

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verification email sent! Please check your inbox."),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }

                  if (!context.mounted) return;

                  // 3. التوجيه لصفحة التحقق فقط لو مفيش أخطاء
                  context.push(
                    AppRoutes.verificationCode,
                    extra: VerificationCodeArgs(
                      contact: _emailController.text.trim(),
                      contactType: VerificationContactType.email,
                      onVerified: () {
                        if (context.mounted) {
                          context.push(AppRoutes.inputPhoneNumber);
                        }
                      },
                    ),
                  );
                } catch (e) {
                  // === نقطة التوقف الإجبارية لمنع الإكمال بأي شكل ===
                  if (!context.mounted) return;

                  bool isAlreadyInUse = false;
                  String errorMessage = "Error: $e";

                  if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
                    isAlreadyInUse = true;
                    errorMessage = "This email is already registered. Please sign in.";
                  } else if (e.toString().contains('email-already-in-use')) {
                    isAlreadyInUse = true;
                    errorMessage = "This email is already registered. Please sign in.";
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );

                  // لو الإيميل موجود، توجه فوراً للـ Sign In واعمل return عشان الكود يوقف
                  if (isAlreadyInUse) {
                    context.go(AppRoutes.login);
                  }
                  
                  return; // يمنع تماماً أي استكمال للخطوات التالية
                }
              }
            },
          ),
        ],
      ),
    );
  }
}