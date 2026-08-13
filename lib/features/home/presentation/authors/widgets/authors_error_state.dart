import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';

class AuthorsErrorState extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const AuthorsErrorState({
    super.key,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: context.colors.error),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: context.type.bodyMediumMedium.copyWith(
                color: context.colors.title,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 16.h),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 240.w),
              child: PrimaryButton(text: retryLabel, onPressed: onRetry),
            ),
          ],
        ),
      ),
    );
  }
}
