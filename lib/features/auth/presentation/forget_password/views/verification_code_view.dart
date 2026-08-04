import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_otp_field.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/responsive/responsive_builder.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/verification_contact_type.dart';
import 'package:bookapp/features/auth/presentation/forget_password/widgets/resend_code_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../l10n/app_localizations.dart';

class VerificationCodeView extends StatelessWidget {
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
            } else {
              context.go(AppRoutes.login);
            }
          },
        ),
      ),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobile: (context) => _buildOtpContent(context, l10n, isMobile: true),
          tablet: (context) => _buildOtpContent(context, l10n, isMobile: false),
          desktop: (context) => _buildOtpContent(context, l10n, isMobile: false),
        ),
      ),
    );
  }

  Widget _buildOtpContent(
    BuildContext context,
    AppLocalizations l10n, {
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
                      l10n.verifySubtitleWithContact(contactType.title),
                      style: AppTextStyles.bodyLargeRegular.copyWith(
                        color: AppColors.grey500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      contact,
                      style: AppTextStyles.bodyLargeRegular.copyWith(
                        color: AppColors.grey500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(AppSpacing.xxxl),
                    AppOtpField(onCompleted: (value) {}),
                    const Gap(AppSpacing.md),
                    Center(child: ResendCodeSection(onResend: () {})),
                    const Spacer(),
                    const Gap(AppSpacing.xl),
                    PrimaryButton(
                      text: l10n.verifyButton,
                      onPressed: onVerified,
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
