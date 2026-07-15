import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class ResendCodeSection extends StatelessWidget {
  const ResendCodeSection({super.key, required this.onResend});

  final VoidCallback onResend;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code?",
          style: AppTextStyles.bodyLargeRegular.copyWith(
            color: AppColors.grey500,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Handle resend code action
          },
          child: Text(
            ' Resend',
            style: AppTextStyles.bodyLargeMedium.copyWith(
              color: AppColors.primary500,
            ),
          ),
        ),
      ],
    );
  }
}
