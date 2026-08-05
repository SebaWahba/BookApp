import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_password_field.dart';
import 'package:bookapp/core/components/inputs/app_text_field.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/utils/snackbar_utils.dart';
import 'package:bookapp/features/profile/domain/entities/user_entity.dart';
import 'package:bookapp/features/profile/presentation/providers/profile_controller.dart';
import 'package:bookapp/features/profile/presentation/widgets/profile_image_section.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAccountView extends ConsumerStatefulWidget {
  const MyAccountView({super.key});

  @override
  ConsumerState<MyAccountView> createState() => _MyAccountViewState();
}

class _MyAccountViewState extends ConsumerState<MyAccountView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _populateFields(UserEntity user) {
    if (!_isInitialized) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(profileControllerProvider);

    profileAsync.whenData((user) => _populateFields(user));

    final isLoading = profileAsync.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myAccountTitle, style: AppTextStyles.h4)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(child: ProfileImageSection()),
              Gap(AppSpacing.xxxl.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.nameLabel, style: AppTextStyles.bodyMediumMedium),
                  Gap(AppSpacing.sm.h),
                  AppTextField(controller: _nameController),
                  Gap(AppSpacing.sm.h),
                  Text(l10n.emailLabel, style: AppTextStyles.bodyMediumMedium),
                  Gap(AppSpacing.sm.h),
                  AppTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Gap(AppSpacing.sm.h),
                  Text(l10n.phoneLabel, style: AppTextStyles.bodyMediumMedium),
                  Gap(AppSpacing.sm.h),
                  AppTextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(
                      Icons.phone_rounded,
                      color: AppColors.primary500,
                    ),
                  ),
                  Gap(AppSpacing.sm.h),
                  Text(
                    l10n.passwordLabel,
                    style: AppTextStyles.bodyMediumMedium,
                  ),
                  Gap(AppSpacing.sm.h),
                  AppPasswordField(controller: _passwordController),
                  Gap(AppSpacing.xxxl.h),
                  PrimaryButton(
                    text: isLoading ? l10n.loading : l10n.saveChanges,
                    onPressed: isLoading
                        ? null
                        : () async {
                            final success = await ref
                                .read(profileControllerProvider.notifier)
                                .updateProfile(
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  password: _passwordController.text.isNotEmpty
                                      ? _passwordController.text
                                      : null,
                                );
                            if (success && context.mounted) {
                              _passwordController.clear();
                              SnackbarUtils.showSuccess(
                                context,
                                'Profile updated successfully!',
                              );
                            }
                          },
                  ),
                  Gap(AppSpacing.xxxl.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
