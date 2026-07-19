import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_password_field.dart';
import 'package:bookapp/core/components/inputs/app_text_field.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/constants/app_strings.dart';
import 'package:bookapp/core/utils/regex_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
                  "Sign Up",
                  style:
                      theme.textTheme.headlineLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold) ??
                      const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 8),
                Text(
                  "Create account and choose favorite menu",
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey500) ??
                      const TextStyle(fontSize: 16, color: AppColors.grey500),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _nameController,
                  hintText: "Your name",
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.grey500),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.valNameEmpty;
                    }
                    if (value.trim().split(' ').length < 2) {
                      return AppStrings.valNameInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _emailController,
                  hintText: "Your email",
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.grey500),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.valEmailEmpty;
                    }
                    if (!RegexValidators.isEmail(value)) {
                      return AppStrings.valEmailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppPasswordField(
                  controller: _passwordController,
                  hintText: "Your password",
                  validator: (value) => RegexValidators.passwordValidator(value),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Register',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      GoRouter.of(context).go(AppRoutes.splash);
                    }
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account? ",
                      style:
                          theme.textTheme.bodyMedium?.copyWith(color: AppColors.grey500) ??
                          const TextStyle(color: AppColors.grey500),
                    ),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).go(AppRoutes.login);
                      },
                      child: Text(
                        "Sign In",
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
                const SizedBox(height: 40),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "By clicking Register, you agree to our\nTerms and Data Policy.",
                      textAlign: TextAlign.center,
                      style:
                          theme.textTheme.bodySmall?.copyWith(color: AppColors.grey400, height: 1.4) ??
                          const TextStyle(fontSize: 12, color: AppColors.grey400),
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
