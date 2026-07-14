import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

class PasswordRequirementsCard extends StatelessWidget {
  const PasswordRequirementsCard({
    super.key,
    required this.hasMinLength,
    required this.hasNumber,
    required this.hasLetter,
  });
  final bool hasMinLength;
  final bool hasNumber;
  final bool hasLetter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PasswordRequirementItem(
            isValid: hasMinLength,
            text: 'Minimum 8 characters',
          ),
          const SizedBox(height: 8),
          PasswordRequirementItem(
            isValid: hasNumber,
            text: 'At least 1 number (1-9)',
          ),
          const SizedBox(height: 8),
          PasswordRequirementItem(
            isValid: hasLetter,
            text: 'At least lowercase or uppercase letters',
          ),
        ],
      ),
    );
  }
}

class PasswordRequirementItem extends StatelessWidget {
  const PasswordRequirementItem({
    super.key,
    required this.isValid,
    required this.text,
  });
  final bool isValid;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? AppColors.primary500 : AppColors.grey500,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: isValid ? AppColors.primary500 : AppColors.grey500,
          ),
        ),
      ],
    );
  }
}
