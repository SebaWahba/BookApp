import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_password_field.dart';
import 'package:bookapp/core/components/inputs/password_requirements_card.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/responsive/responsive_builder.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/core/utils/regex_validators.dart';
import 'package:bookapp/core/utils/snackbar_utils.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/success_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../models/forget_password_error.dart';
import '../providers/forget_password_notifier.dart';

class CreateNewPasswordView extends ConsumerStatefulWidget {
  const CreateNewPasswordView({super.key});

  @override
  ConsumerState<CreateNewPasswordView> createState() =>
      _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends ConsumerState<CreateNewPasswordView> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasLetter = false;

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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    ref
        .read(forgetPasswordProvider.notifier)
        .updatePassword(_newPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(forgetPasswordProvider);

    ref.listen<ForgetPasswordState>(forgetPasswordProvider, (previous, next) {
      if (previous?.status != ForgetPasswordStatus.loading) return;

      if (next.succeeded(ForgetPasswordStep.updatePassword)) {
        context.go(AppRoutes.success, extra: SuccessType.resetPassword);
        return;
      }

      if (next.failed(ForgetPasswordStep.updatePassword) &&
          next.error != null) {
        SnackbarUtils.showError(
          context,
          next.error!.message(l10n, contactType: next.selectedContactType),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobile: (context) =>
              _buildPasswordForm(context, l10n, state, isMobile: true),
          tablet: (context) =>
              _buildPasswordForm(context, l10n, state, isMobile: false),
          desktop: (context) =>
              _buildPasswordForm(context, l10n, state, isMobile: false),
        ),
      ),
    );
  }

  Widget _buildPasswordForm(
      BuildContext context,
      AppLocalizations l10n,
      ForgetPasswordState state, {
        required bool isMobile,
      }) {
    final isSaving =
        state.isLoading && state.step == ForgetPasswordStep.updatePassword;

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
                  Text(
                    l10n.newPasswordTitle,
                    style: context.type.h3.copyWith(color: context.colors.title),
                  ),
                  const Gap(AppSpacing.sm),
                  Text(
                    l10n.newPasswordSubtitle,
                    style: context.type.bodyLargeRegular.copyWith(
                      color: context.colors.body,
                    ),
                  ),
                  const Gap(AppSpacing.xxl),
                  Text(
                    l10n.newPasswordLabel,
                    style: context.type.bodyMediumMedium.copyWith(color: context.colors.title),
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
                    style: context.type.bodyMediumMedium.copyWith(color: context.colors.title),
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
                    text: isSaving ? l10n.savingButton : l10n.sendButton,
                    onPressed: state.isLoading ? null : _submit,
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