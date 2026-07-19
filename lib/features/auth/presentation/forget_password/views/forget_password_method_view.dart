import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/verification_contact_type.dart';
import '../widgets/content_method_card.dart';
import '../providers/forget_password_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgetPasswordMethodView extends ConsumerWidget {
  const ForgetPasswordMethodView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedContactTypeProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Forget Password', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Select which contact details we should use to reset your password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w200,
                  color: Color(0XFFA6A6A6),
                ),
              ),
              Spacer(flex: 1),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ContactMethodCard(
                      image: AppAssets.email,
                      title: 'Email',
                      subtitle: 'Send to your email',
                      isSelected: selectedType == VerificationContactType.email,
                      onTap: () {
                        ref
                            .read(selectedContactTypeProvider.notifier)
                            .state = VerificationContactType.email;
                      }
                  ),
                  ContactMethodCard(
                      image: AppAssets.phone,
                      title: 'Phone Number',
                      subtitle: 'Send to your phone',
                      isSelected: selectedType == VerificationContactType.phone,
                      onTap: () {
                        ref
                            .read(selectedContactTypeProvider.notifier)
                            .state = VerificationContactType.phone;
                      }
                  ),
                ],
              ),
              const Spacer(flex: 1),
            PrimaryButton(
              text: 'Continue',
              onPressed: () {
                if (selectedType == null) return;

                context.push(
                  AppRoutes.resetPassword,
                  extra: selectedType,
                );
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
