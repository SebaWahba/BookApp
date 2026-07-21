import 'package:bookapp/core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/routes/app_router.dart';
import '../../../../../config/routes/app_routes.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/components/buttons/primary_button.dart';
import '../../../../../core/components/inputs/app_text_field.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/regex_validators.dart';
import '../models/verification_contact_type.dart';
import '../providers/forget_password_notifier.dart';

class ResetPasswordView extends ConsumerStatefulWidget {
  const ResetPasswordView({super.key, required this.type});

  final VerificationContactType type;

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(forgetPasswordProvider);
    final isLoading = sendState.status == ForgetPasswordStatus.loading;

    ref.listen<ForgetPasswordState>(forgetPasswordProvider, (previous, next) {
      if (previous?.status == ForgetPasswordStatus.loading && next.status == ForgetPasswordStatus.success) {
        SnackbarUtils.showSuccess(context, 'Verification code sent to your ${widget.type.title}!');

        context.push(
          AppRoutes.verificationCode,
          extra: VerificationCodeArgs(
            contact: _inputController.text.trim(),
            contactType: widget.type,
            onVerified: () => context.push(AppRoutes.createNewPassword),
          ),
        );
      }

      if (next.status == ForgetPasswordStatus.error) {
        SnackbarUtils.showError(context, 'Error: ${next.errorMessage}');
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: context.pop, icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reset Password', style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.sm),

                Text(widget.type.description),

                const Spacer(),

                Text(widget.type.title),
                const SizedBox(height: 8),

                AppTextField(
                  controller: _inputController,
                  hintText: widget.type.hint,
                  prefixIcon: widget.type.prefixIcon == null ? null : Icon(widget.type.prefixIcon),
                  validator: (value) {
                    final input = value?.trim() ?? '';

                    if (input.isEmpty) {
                      return '${widget.type.title} is required';
                    }

                    if (widget.type == VerificationContactType.email) {
                      if (!RegexValidators.isEmail(input)) {
                        return 'Please enter a valid email address';
                      }
                    }

                    if (widget.type == VerificationContactType.phone) {
                      final isValidPhone = RegExp(r'^[0-9+ ]+$').hasMatch(input) && input.length >= 11;

                      if (!isValidPhone) {
                        return 'Please enter a valid phone number';
                      }
                    }

                    return null;
                  },
                ),

                const Spacer(),

                PrimaryButton(
                  text: isLoading ? 'Sending...' : 'Send',
                  onPressed: () {
                    if (isLoading) return;

                    if (!_formKey.currentState!.validate()) return;

                    ref
                        .read(forgetPasswordProvider.notifier)
                        .sendVerificationCode(type: widget.type, input: _inputController.text.trim());
                  },
                ),

                const Spacer(flex: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
