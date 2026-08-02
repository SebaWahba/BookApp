import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';

class AuthorsEmptyState extends StatelessWidget {
  final String message;

  const AuthorsEmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 48.sp,
            color: AppColors.vendorSubtleText,
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            style: AppTextStyles.bodyMediumMedium.copyWith(
              color: AppColors.vendorSubtleText,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
