import 'dart:io';

import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
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
        color: context.colors.surface,
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
              color: context.colors.divider,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Gap(AppSpacing.xl.h),
          Text(
            l10n.pickImageTitle,
            style: context.type.h5.copyWith(color: context.colors.title),
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
      color: context.colors.primarySurface,
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
              Icon(icon, color: context.colors.primary, size: 24.sp),
              Gap(AppSpacing.lg.w),
              Text(
                label,
                style: context.type.bodyLargeSemiBold.copyWith(
                  color: context.colors.primary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: context.colors.primary,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}