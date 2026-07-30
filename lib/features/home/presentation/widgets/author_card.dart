import 'package:flutter/material.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';

class AuthorCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;
  final double width;

  const AuthorCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.role,
    this.width = 110.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.asset(
              imagePath,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: AppTextStyles.bodyLargeMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: AppTextStyles.bodySmallRegular.copyWith(
              color: AppColors.grey500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
