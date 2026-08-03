import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';

import '../../../../../config/themes/app_colors.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/components/buttons/primary_button.dart';
import '../../../../../core/constants/app_spacing.dart';

class SimulatedOtpBottomSheet extends StatelessWidget {
  const SimulatedOtpBottomSheet({
    super.key,
    required this.contact,
    required this.otpCode,
    this.onContinue,
  });

  final String contact;
  final String otpCode;
  final VoidCallback? onContinue;

  static Future<void> show(
      BuildContext context, {
        required String contact,
        required String otpCode,
        VoidCallback? onContinue,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SimulatedOtpBottomSheet(
        contact: contact,
        otpCode: otpCode,
        onContinue: onContinue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.pagePadding,
        right: AppSpacing.pagePadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(AppSpacing.lg),
          const Icon(
            Icons.mark_email_read_outlined,
            size: 48,
            color: AppColors.primary500,
          ),
          const Gap(AppSpacing.md),
          Text(
            'Verification Code Delivered',
            style: AppTextStyles.h4,
            textAlign: TextAlign.center,
          ),
          const Gap(AppSpacing.xs),
          Text(
            'Simulated code delivery for $contact:',
            style: AppTextStyles.bodyMediumRegular.copyWith(
              color: AppColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary500, width: 1.5),
            ),
            child: Text(
              otpCode,
              style: AppTextStyles.h1.copyWith(
                letterSpacing: 8,
                color: AppColors.primary500,
              ),
            ),
          ),
          const Gap(AppSpacing.xxl),
          PrimaryButton(
            text: 'Copy & Continue',
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: otpCode));
              if (context.mounted) {
                Navigator.pop(context);
                onContinue?.call();
              }
            },
          )
        ],
      ),
    );
  }
}