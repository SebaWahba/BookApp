import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationErrorState extends StatelessWidget {
  const LocationErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: AppTextStyles.bodyMediumRegular.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm.h),
            TextButton(onPressed: onRetry, child: Text(l10n.retryButton)),
          ],
        ),
      ),
    );
  }
}
