import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SignUpHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h3,
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: AppColors.grey500,
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}
