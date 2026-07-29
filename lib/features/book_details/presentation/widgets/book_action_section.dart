import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/components/buttons/primary_button.dart';
import '../../../../core/components/buttons/secondary_button.dart';
import '../../../../l10n/app_localizations.dart';

class BookActionSection extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String price;

  const BookActionSection({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.vendorCardBackground,
                borderRadius: BorderRadius.circular(24.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: onDecrement,
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.grey200,
                      ),
                      child: Icon(
                        Icons.remove,
                        color: AppColors.grey500,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  Gap(16.w),
                  Text("$quantity", style: AppTextStyles.bodyLargeMedium),
                  Gap(16.w),
                  InkWell(
                    onTap: onIncrement,
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary600,
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(24.w),
            Expanded(
              child: Text(
                price,
                style: AppTextStyles.h5.copyWith(color: AppColors.primary600),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Gap(24.h),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.r),
                child: PrimaryButton(
                  text: l10n.continueShopping,
                  verticalPadding: 16.0,
                  onPressed: () {},
                ),
              ),
            ),
            Gap(16.w),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.r),
                child: SecondaryButton(text: l10n.viewCart, onPressed: () {}),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
