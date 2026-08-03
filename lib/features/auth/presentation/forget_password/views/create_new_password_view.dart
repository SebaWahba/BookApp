import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_password_field.dart';
import 'package:bookapp/core/components/inputs/password_requirements_card.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/responsive/responsive_builder.dart';
import 'package:bookapp/core/utils/regex_validators.dart';
import 'package:bookapp/core/utils/snackbar_utils.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/success_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../l10n/app_localizations.dart';

class CreateNewPasswordView extends StatefulWidget {
  const CreateNewPasswordView({super.key});

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasLetter = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _hasMinLength = RegexValidators.hasMinLength(value);
      _hasNumber = RegexValidators.hasNumber(value);
      _hasLetter = RegexValidators.hasLetter(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobile: (context) => _buildPasswordForm(context, l10n, isMobile: true),
          tablet: (context) => _buildPasswordForm(context, l10n, isMobile: false),
          desktop: (context) => _buildPasswordForm(context, l10n, isMobile: false),
        ),
      ),
    );
  }

  Widget _buildPasswordForm(
    BuildContext context,
    AppLocalizations l10n, {
    required bool isMobile,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.screenPadding : 32.0,
            vertical: AppSpacing.lg,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.newPasswordTitle, style: AppTextStyles.h3),
                  const Gap(AppSpacing.sm),
                  Text(
                    l10n.newPasswordSubtitle,
                    style: AppTextStyles.bodyLargeRegular.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  const Gap(AppSpacing.xxl),
                  Text(
                    l10n.newPasswordLabel,
                    style: AppTextStyles.bodyMediumMedium,
                  ),
                  const Gap(AppSpacing.sm),
                  AppPasswordField(
                    controller: _newPasswordController,
                    onChanged: _onPasswordChanged,
                    validator: RegexValidators.passwordValidator,
                  ),
                  const Gap(AppSpacing.sm),
                  PasswordRequirementsCard(
                    hasMinLength: _hasMinLength,
                    hasNumber: _hasNumber,
                    hasLetter: _hasLetter,
                  ),
                  const Gap(AppSpacing.sm),
                  Text(
                    l10n.confirmPasswordLabel,
                    style: AppTextStyles.bodyMediumMedium,
                  ),
                  const Gap(AppSpacing.sm),
                  AppPasswordField(
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.valConfirmPasswordEmpty;
                      }

                      if (value != _newPasswordController.text) {
                        return l10n.valPasswordMismatch;
                      }

                      return null;
                    },
                  ),
                  const Gap(AppSpacing.xxxl),
                  PrimaryButton(
                    text: l10n.sendButton,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        SnackbarUtils.showSuccess(
                          context,
                          SuccessType.resetPassword.description,
                        );
                        context.go(
                          AppRoutes.success,
                          extra: SuccessType.resetPassword,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}