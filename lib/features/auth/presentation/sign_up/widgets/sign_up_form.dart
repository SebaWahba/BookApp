import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_password_field.dart';
import 'package:bookapp/core/components/inputs/app_text_field.dart';
import 'package:bookapp/core/components/inputs/password_requirements_card.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/utils/regex_validators.dart';
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

    // تم إزالة الـ ref.listen من هنا تماماً لمنع التداخل وتكرار عرض الأخطاء (لأن الـ SignUpView مسؤولة عنه مركزياً)

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
            onPressed: authState.isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      ref.read(authProvider.notifier).clearError();

                      await ref
                          .read(authProvider.notifier)
                          .signUp(
                            name: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
