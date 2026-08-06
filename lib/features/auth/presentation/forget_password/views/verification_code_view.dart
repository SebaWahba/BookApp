import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_otp_field.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/responsive/responsive_builder.dart';
import 'package:bookapp/core/utils/snackbar_utils.dart';
import 'package:bookapp/features/auth/presentation/forget_password/widgets/resend_code_section.dart';
import 'package:bookapp/features/auth/presentation/forget_password/widgets/simulated_otp_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../models/forget_password_error.dart';
import '../models/verification_contact_type.dart';
import '../providers/forget_password_notifier.dart';

/// Verification step of the forgot-password flow.
///
/// Reads the contact and the issued code straight off [forgetPasswordProvider]
/// — the flow owns them, so there is nothing to thread through `extra`.
class VerificationCodeView extends ConsumerStatefulWidget {
  const VerificationCodeView({super.key});

  @override
  ConsumerState<VerificationCodeView> createState() =>
      _VerificationCodeViewState();
}

class _VerificationCodeViewState extends ConsumerState<VerificationCodeView> {
  static const int _codeLength = 4;

  String _code = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final state = ref.read(forgetPasswordProvider);

      // Reached without going through the reset screen (deep link, hot
      // restart) — there is no contact to verify against.
      if (state.contactInput == null || state.contactInput!.isEmpty) {
        context.go(AppRoutes.forgetPassword);
        return;
      }

      final code = state.otpCode;
      if (code != null) _revealSimulatedCode(state.contactInput!, code);
    });
  }

  void _revealSimulatedCode(String contact, String code) {
    SimulatedOtpBottomSheet.show(context, contact: contact, otpCode: code);
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (_code.length < _codeLength) {
      SnackbarUtils.showError(context, l10n.valOtpIncomplete);
      return;
    }

    FocusScope.of(context).unfocus();
    ref.read(forgetPasswordProvider.notifier).verifyCode(_code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(forgetPasswordProvider);

    ref.listen<ForgetPasswordState>(forgetPasswordProvider, (previous, next) {
      // Guarded on the previous status so the resend countdown, which rewrites
      // state every second, can't re-trigger any of these.
      if (previous?.status != ForgetPasswordStatus.loading) return;

      if (next.succeeded(ForgetPasswordStep.verifyCode)) {
        context.push(AppRoutes.createNewPassword);
        return;
      }

      if (next.succeeded(ForgetPasswordStep.resendCode)) {
        SnackbarUtils.showSuccess(context, l10n.codeResentConfirmation);
        final code = next.otpCode;
        if (code != null) _revealSimulatedCode(next.contactInput ?? '', code);
        return;
      }

      // Only this screen's own steps — Create New Password stays pushed on top
      // of this one, so an unfiltered error branch would double up its snackbar.
      final failedHere =
          next.failed(ForgetPasswordStep.verifyCode) ||
          next.failed(ForgetPasswordStep.resendCode);
      if (failedHere && next.error != null) {
        SnackbarUtils.showError(
          context,
          next.error!.message(l10n, contactType: next.selectedContactType),
        );
      }
    });

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
            } else {
              context.go(AppRoutes.login);
            }
          },
        ),
      ),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobile: (context) => _buildOtpContent(context, l10n, state, isMobile: true),
          tablet: (context) => _buildOtpContent(context, l10n, state, isMobile: false),
          desktop: (context) => _buildOtpContent(context, l10n, state, isMobile: false),
        ),
      ),
    );
  }

  Widget _buildOtpContent(
    BuildContext context,
    AppLocalizations l10n,
    ForgetPasswordState state, {
    required bool isMobile,
  }) {
    final contactType = state.selectedContactType;
    final isVerifying =
        state.isLoading && state.step == ForgetPasswordStep.verifyCode;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.pagePadding : 32.0,
            vertical: AppSpacing.lg,
          ),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(l10n.verifyTitle, style: AppTextStyles.h3),
                    const Gap(AppSpacing.xs),
                    if (contactType != null)
                      Text(
                        l10n.verifySubtitleWithContact(contactType.title),
                        style: AppTextStyles.bodyLargeRegular.copyWith(
                          color: AppColors.grey500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    Text(
                      state.contactInput ?? '',
                      style: AppTextStyles.bodyLargeRegular.copyWith(
                        color: AppColors.grey500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(AppSpacing.xxxl),
                    AppOtpField(
                      length: _codeLength,
                      enabled: !state.isLoading,
                      onChanged: (value) => _code = value,
                      onCompleted: (value) {
                        _code = value;
                        _submit();
                      },
                    ),
                    const Gap(AppSpacing.md),
                    Center(
                      child: ResendCodeSection(
                        onResend: () => ref
                            .read(forgetPasswordProvider.notifier)
                            .resendCode(),
                      ),
                    ),
                    const Spacer(),
                    const Gap(AppSpacing.xl),
                    PrimaryButton(
                      text: isVerifying
                          ? l10n.verifyingButton
                          : l10n.verifyButton,
                      onPressed: state.isLoading ? null : _submit,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
