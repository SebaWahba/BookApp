import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyAddressesState extends StatelessWidget {
  const EmptyAddressesState({super.key, required this.onNewAddress});

  final VoidCallback onNewAddress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96.r,
            height: 96.r,
            decoration: const BoxDecoration(
              color: AppColors.primary100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_off_rounded,
              color: AppColors.primary400,
              size: 48.r,
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Text(
            l10n.noSavedAddresses,
            style: AppTextStyles.h5.copyWith(color: AppColors.grey700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xl.h),
          SizedBox(
            width: 220.w,
            child: PrimaryButton(
              text: l10n.newAddress,
              onPressed: onNewAddress,
            ),
          ),
        ],
      ),
    );
  }
}
