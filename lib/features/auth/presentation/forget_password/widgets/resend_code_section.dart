import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';

class ResendCodeSection extends StatelessWidget {
  const ResendCodeSection({super.key, required this.onResend});

  final VoidCallback onResend;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.resendText,
          style: AppTextStyles.bodyLargeRegular.copyWith(
            color: AppColors.grey500,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Handle resend code action
          },
          child: Text(
            l10n.resendButton,
            style: AppTextStyles.bodyLargeMedium.copyWith(
              color: AppColors.primary500,
            ),
          ),
        ),
      ],
    );
  }
}
