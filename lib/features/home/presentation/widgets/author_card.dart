import 'package:flutter/material.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';

class AuthorCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;

  const AuthorCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            imagePath,
            width: 102,
            height: 102,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 126,
          child: Text(
            name,
            style: AppTextStyles.bodyLargeMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          role,
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: AppColors.grey500,
          ),
        ),
      ],
    );
  }
}
