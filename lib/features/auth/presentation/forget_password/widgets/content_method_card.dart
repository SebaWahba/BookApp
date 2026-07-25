import 'package:flutter/material.dart';

import '../../../../../config/themes/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';

class ContactMethodCard extends StatelessWidget {
  const ContactMethodCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isSelected,
  });

  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 165,
        height: 155,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F4F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary500 : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(image),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontWeight: FontWeight.w200,
                color: Color(0xFFA6A6A6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
