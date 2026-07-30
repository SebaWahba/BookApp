import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/routes/app_router.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/responsive/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../models/verification_contact_type.dart';
import '../providers/forget_password_notifier.dart';
import '../widgets/content_method_card.dart';

class ForgetPasswordMethodView extends ConsumerWidget {
  const ForgetPasswordMethodView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(forgetPasswordProvider).selectedContactType;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
        ),
      ),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobile: (context) => _buildMethodForm(
            context,
            ref,
            selectedType,
            l10n,
            isMobile: true,
          ),
          tablet: (context) => _buildMethodForm(
            context,
            ref,
            selectedType,
            l10n,
            isMobile: false,
          ),
          desktop: (context) => _buildMethodForm(
            context,
            ref,
            selectedType,
            l10n,
            isMobile: false,
          ),
        ),
      ),
    );
  }

  Widget _buildMethodForm(
    BuildContext context,
    WidgetRef ref,
    VerificationContactType? selectedType,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.forgetPasswordTitle, style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.forgetPasswordSubtitle,
                      style: AppTextStyles.bodyMediumRegular.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: ContactMethodCard(
                            image: AppAssets.email,
                            title: l10n.contactMethodEmailTitle,
                            subtitle: l10n.contactMethodEmailSubtitle,
                            isSelected:
                                selectedType == VerificationContactType.email,
                            onTap: () {
                              ref
                                  .read(forgetPasswordProvider.notifier)
                                  .selectContactType(
                                      VerificationContactType.email);
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: ContactMethodCard(
                            image: AppAssets.phone,
                            title: l10n.contactMethodPhoneTitle,
                            subtitle: l10n.contactMethodPhoneSubtitle,
                            isSelected:
                                selectedType == VerificationContactType.phone,
                            onTap: () {
                              ref
                                  .read(forgetPasswordProvider.notifier)
                                  .selectContactType(
                                      VerificationContactType.phone);
                            },
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      text: l10n.continueButton,
                      onPressed: selectedType == null
                          ? null
                          : () {
                              if (selectedType ==
                                  VerificationContactType.phone) {
                                context.push(
                                  AppRoutes.inputPhoneNumber,
                                  extra: (String phone) {
                                    context.push(
                                      AppRoutes.verificationCode,
                                      extra: VerificationCodeArgs(
                                        contact: phone,
                                        contactType:
                                            VerificationContactType.phone,
                                        onVerified: () => context
                                            .push(AppRoutes.createNewPassword),
                                      ),
                                    );
                                  },
                                );
                                return;
                              }

                              context.push(
                                AppRoutes.resetPassword,
                                extra: selectedType,
                              );
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
