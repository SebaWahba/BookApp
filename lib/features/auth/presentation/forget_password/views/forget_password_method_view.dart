import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/routes/app_router.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
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
      appBar: AppBar(
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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
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
              Spacer(flex: 1),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ContactMethodCard(
                    image: AppAssets.email,
                    title: l10n.contactMethodEmailTitle,
                    subtitle: l10n.contactMethodEmailSubtitle,
                    isSelected: selectedType == VerificationContactType.email,
                    onTap: () {
                      ref
                          .read(forgetPasswordProvider.notifier)
                          .selectContactType(VerificationContactType.email);
                    },
                  ),
                  ContactMethodCard(
                    image: AppAssets.phone,
                    title: l10n.contactMethodPhoneTitle,
                    subtitle: l10n.contactMethodPhoneSubtitle,
                    isSelected: selectedType == VerificationContactType.phone,
                    onTap: () {
                      ref
                          .read(forgetPasswordProvider.notifier)
                          .selectContactType(VerificationContactType.phone);
                    },
                  ),
                ],
              ),
              const Spacer(flex: 1),
              PrimaryButton(
                text: l10n.continueButton,
                onPressed: () {
                  if (selectedType == null) return;

                  if (selectedType == VerificationContactType.phone) {
                    context.push(
                      AppRoutes.inputPhoneNumber,
                      extra: (String phone) {
                        context.push(
                          AppRoutes.verificationCode,
                          extra: VerificationCodeArgs(
                            contact: phone,
                            contactType: VerificationContactType.phone,
                            onVerified: () =>
                                context.push(AppRoutes.createNewPassword),
                          ),
                        );
                      },
                    );
                    return;
                  }

                  context.push(AppRoutes.resetPassword, extra: selectedType);
                },
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
