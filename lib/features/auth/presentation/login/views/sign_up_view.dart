import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/routes/app_router.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/constants/app_strings.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/verification_contact_type.dart';
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
  bool _obscureText = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.grey900),
                  onPressed: () => GoRouter.of(context).pop(),
                ),
                const SizedBox(height: 20),
                const Text(
                  AppStrings.signUpTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.signUpSubtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: AppStrings.fullNameLabel,
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary500),
                    labelStyle: const TextStyle(color: AppColors.grey500),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary500),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.grey300),
                    ),
                  ),
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
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: AppStrings.emailLabel,
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary500),
                    labelStyle: const TextStyle(color: AppColors.grey500),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary500),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.grey300),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.valEmailEmpty;
                    }
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return AppStrings.valEmailInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    labelText: AppStrings.passwordLabel,
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary500),
                    labelStyle: const TextStyle(color: AppColors.grey500),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.primary500,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary500),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.grey300),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.valPasswordEmpty;
                    }
                    if (value.length < 8) {
                      return AppStrings.valPasswordLength;
                    }
                    if (!value.contains(RegExp(r'[A-Z]'))) {
                      return AppStrings.valPasswordUppercase;
                    }
                    if (!value.contains(RegExp(r'[0-9]'))) {
                      return AppStrings.valPasswordNumber;
                    }
                    if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
                      return AppStrings.valPasswordSpecial;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      GoRouter.of(context).push(
                        AppRoutes.verificationCode,
                        extra: VerificationCodeArgs(
                          contact: _emailController.text,
                          contactType: VerificationContactType.email,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    AppStrings.signUpLink,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(AppStrings.alreadyHaveAccount, style: TextStyle(color: AppColors.grey900)),
                    TextButton(
                      onPressed: () => GoRouter.of(context).go(AppRoutes.login),
                      child: const Text(
                        AppStrings.signInLink,
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}