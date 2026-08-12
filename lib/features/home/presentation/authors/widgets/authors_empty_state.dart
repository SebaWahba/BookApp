import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';

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
            color: context.colors.body,
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            style: context.type.bodyMediumMedium.copyWith(
              color: context.colors.body,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
