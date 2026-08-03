import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_otp_field.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/enums/verification_status.dart';
import 'package:bookapp/core/responsive/responsive_builder.dart';
import 'package:bookapp/core/utils/snackbar_utils.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/verification_contact_type.dart';
import 'package:bookapp/features/auth/presentation/forget_password/providers/forget_password_notifier.dart';
import 'package:bookapp/features/auth/presentation/forget_password/widgets/resend_code_section.dart';
import 'package:bookapp/features/auth/presentation/phone_verification/providers/phone_verification_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../l10n/app_localizations.dart';

class VerificationCodeView extends ConsumerStatefulWidget {
  const VerificationCodeView({
    super.key,
    required this.contact,
    required this.contactType,
    required this.onVerified,
  });

  final String contact;
  final VerificationContactType contactType;
  final VoidCallback onVerified;

  @override
  ConsumerState<VerificationCodeView> createState() => _VerificationCodeViewState();
}

class _VerificationCodeViewState extends ConsumerState<VerificationCodeView> {
  String _enteredCode = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final phoneState = ref.watch(phoneVerificationProvider);
    final forgetState = ref.watch(forgetPasswordProvider);
    final isLoading = phoneState.status == PhoneVerificationStatus.loading ||
        forgetState.status == ForgetPasswordStatus.loading;

    ref.listen<PhoneVerificationState>(phoneVerificationProvider, (previous, next) {
      if (previous?.status == PhoneVerificationStatus.loading &&
          next.status == PhoneVerificationStatus.success) {
        widget.onVerified();
      }

      if (next.status == PhoneVerificationStatus.error && next.errorMessage != null) {
        if (mounted) {
          SnackbarUtils.showError(context, next.errorMessage!);
        }
      }
    });

    ref.listen<ForgetPasswordState>(forgetPasswordProvider, (previous, next) {
      if (previous?.status == ForgetPasswordStatus.loading &&
          next.status == ForgetPasswordStatus.success) {
        widget.onVerified();
      }

      if (next.status == ForgetPasswordStatus.error && next.errorMessage != null) {
        if (mounted) {
          SnackbarUtils.showError(context, next.errorMessage!);
        }
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
          mobile: (context) => _buildOtpContent(context, l10n, isLoading, isMobile: true),
          tablet: (context) => _buildOtpContent(context, l10n, isLoading, isMobile: false),
          desktop: (context) => _buildOtpContent(context, l10n, isLoading, isMobile: false),
        ),
      ),
    );
  }

  Widget _buildOtpContent(
    BuildContext context,
    AppLocalizations l10n,
    bool isLoading, {
    required bool isMobile,
  }) {
    final isPhone = widget.contactType == VerificationContactType.phone;
    final expectedOtpLength = isPhone ? 6 : 4;
    final isCodeComplete = _enteredCode.length == expectedOtpLength;
    final displayContact = widget.contact.isEmpty ? '---' : widget.contact;

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
                    Text(
                      l10n.verifySubtitleWithContact(widget.contactType.title),
                      style: AppTextStyles.bodyLargeRegular.copyWith(
                        color: AppColors.grey500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      displayContact,
                      style: AppTextStyles.bodyLargeRegular.copyWith(
                        color: AppColors.grey500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(AppSpacing.xxxl),
                    // Wrapped AppOtpField in FittedBox to scale down smoothly on small screens
                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: AppOtpField(
                          length: expectedOtpLength,
                          onChanged: (value) {
                            setState(() {
                              _enteredCode = value;
                            });
                          },
                          onCompleted: (value) {
                            setState(() {
                              _enteredCode = value;
                            });
                            if (isPhone) {
                              ref
                                  .read(phoneVerificationProvider.notifier)
                                  .verifyCode(value);
                            } else {
                              ref
                                  .read(forgetPasswordProvider.notifier)
                                  .verifyOtpCode(value);
                            }
                          },
                        ),
                      ),
                    ),
                    const Gap(AppSpacing.md),
                    Center(
                      child: ResendCodeSection(
                        onResend: () {
                          if (isPhone) {
                            ref
                                .read(phoneVerificationProvider.notifier)
                                .sendCode(widget.contact);
                          } else {
                            ref
                                .read(forgetPasswordProvider.notifier)
                                .sendOtpToEmail(widget.contact);
                          }
                          SnackbarUtils.showSuccess(
                            context,
                            l10n.codeSentConfirmation(widget.contactType.title),
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    const Gap(AppSpacing.xl),
                    PrimaryButton(
                      text: isLoading ? l10n.sendingButton : l10n.verifyButton,
                      onPressed: (isLoading || !isCodeComplete)
                          ? null
                          : () {
                              if (isPhone && _enteredCode.length == 6) {
                                ref
                                    .read(phoneVerificationProvider.notifier)
                                    .verifyCode(_enteredCode);
                              } else if (!isPhone && _enteredCode.length == 4) {
                                ref
                                    .read(forgetPasswordProvider.notifier)
                                    .verifyOtpCode(_enteredCode);
                              }
                            },
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
