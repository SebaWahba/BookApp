import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/theme/extensions/theme_ext.dart';

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: context.colors.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? context.colors.primary : context.colors.stroke,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, height: 32, width: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: context.type.bodyMediumBold.copyWith(color: context.colors.title),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: context.type.bodySmallRegular.copyWith(color: context.colors.hint),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}