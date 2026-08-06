import 'dart:io';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/profile/presentation/providers/profile_providers.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagePickerBottomSheet extends ConsumerWidget {
  const ImagePickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding.w,
        vertical: AppSpacing.xxl.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Gap(AppSpacing.xl.h),
          Text(
            l10n.pickImageTitle,
            style: AppTextStyles.h5,
            textAlign: TextAlign.center,
          ),
          Gap(AppSpacing.xxxl.h),
          _PickerOption(
            icon: Icons.camera_alt_rounded,
            label: l10n.pickFromCamera,
            onTap: () => _pickImage(context, ref, isCamera: true),
          ),
          Gap(AppSpacing.lg.h),
          _PickerOption(
            icon: Icons.photo_library_rounded,
            label: l10n.pickFromGallery,
            onTap: () => _pickImage(context, ref, isCamera: false),
          ),
          Gap(AppSpacing.xl.h),
          Gap(MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref, {
    required bool isCamera,
  }) async {
    final pickerService = ref.read(imagePickerServiceProvider);
    final File? file = isCamera
        ? await pickerService.pickFromCamera()
        : await pickerService.pickFromGallery();

    if (context.mounted) {
      Navigator.pop(context, file);
    }
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary50,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl.w,
            vertical: AppSpacing.lg.h,
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary500, size: 24.sp),
              Gap(AppSpacing.lg.w),
              Text(
                label,
                style: AppTextStyles.bodyLargeSemiBold.copyWith(
                  color: AppColors.primary500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.primary500,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
