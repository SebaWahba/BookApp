import 'package:bookapp/core/utils/snackbar_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/components/buttons/primary_button.dart';
import '../../../../../core/components/inputs/app_text_field.dart';
import '../../../../../core/components/inputs/phone_number_field.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/responsive/responsive_builder.dart';
import '../../../../../core/theme/extensions/theme_ext.dart';
import '../../../../../core/utils/regex_validators.dart';
import '../../../../../l10n/app_localizations.dart';
import '../models/forget_password_error.dart';
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

  /// Must default to the same code sign-up defaults to, or numbers saved there
  /// won't be found here.
  String _dialCode = CountryDialCode.supported.first.dialCode;

  bool get _isPhone => widget.type == VerificationContactType.phone;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final raw = _inputController.text.trim();
    // The lookup matches the stored value, which sign-up composed from a dial
    // code plus the national number, so compose it the same way here.
    final input = _isPhone ? PhoneNumberField.compose(_dialCode, raw) : raw;

    if (kDebugMode && _isPhone) {
      debugPrint(
        '[ForgetPassword] typed "$raw" + dial code "$_dialCode" '
            '-> searching for "$input"',
      );
    }

    ref
        .read(forgetPasswordProvider.notifier)
        .sendCode(type: widget.type, input: input);
  }

  String? _validateContact(String? value, AppLocalizations l10n) {
    final input = value?.trim() ?? '';

    if (input.isEmpty) return l10n.valFieldRequired(widget.type.title);

    if (_isPhone) {
      return RegexValidators.isPhoneNumber(
        PhoneNumberField.compose(_dialCode, input),
      )
          ? null
          : l10n.valPhoneInvalid;
    }

    return RegexValidators.isEmail(input) ? null : l10n.valEmailInvalid;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(forgetPasswordProvider);
    final isSending =
        state.isLoading && state.step == ForgetPasswordStep.sendCode;

    ref.listen<ForgetPasswordState>(forgetPasswordProvider, (previous, next) {
      if (previous?.status != ForgetPasswordStatus.loading) return;

      if (next.succeeded(ForgetPasswordStep.sendCode)) {
        SnackbarUtils.showSuccess(
          context,
          l10n.codeSentConfirmation(widget.type.title),
        );
        context.push(AppRoutes.forgetPasswordVerification);
        return;
      }

      if (next.failed(ForgetPasswordStep.sendCode) && next.error != null) {
        SnackbarUtils.showError(
          context,
          next.error!.message(l10n, contactType: widget.type),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobile: (context) =>
              _buildResetForm(context, l10n, isSending, isMobile: true),
          tablet: (context) =>
              _buildResetForm(context, l10n, isSending, isMobile: false),
          desktop: (context) =>
              _buildResetForm(context, l10n, isSending, isMobile: false),
        ),
      ),
    );
  }

  Widget _buildResetForm(
      BuildContext context,
      AppLocalizations l10n,
      bool isSending, {
        required bool isMobile,
      }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.pagePadding : 32.0,
            vertical: AppSpacing.lg,
          ),
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.resetPasswordTitle,
                        style: context.type.h3.copyWith(color: context.colors.title),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.type.description,
                        style: context.type.bodyMediumRegular.copyWith(
                          color: context.colors.body,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        widget.type.title,
                        style: context.type.bodyMediumSemiBold.copyWith(
                          color: context.colors.title,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_isPhone)
                        PhoneNumberField(
                          controller: _inputController,
                          dialCode: _dialCode,
                          onDialCodeChanged: (value) =>
                              setState(() => _dialCode = value),
                          hintText: widget.type.hint,
                          enabled: !isSending,
                          validator: (value) => _validateContact(value, l10n),
                        )
                      else
                        AppTextField(
                          controller: _inputController,
                          hintText: widget.type.hint,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => _validateContact(value, l10n),
                        ),
                      const Spacer(),
                      const SizedBox(height: AppSpacing.xl),
                      PrimaryButton(
                        text: isSending ? l10n.sendingButton : l10n.sendButton,
                        onPressed: isSending ? null : _submit,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}