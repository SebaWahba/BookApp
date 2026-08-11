import 'dart:io';

import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/core/utils/snackbar_utils.dart';
import 'package:bookapp/features/profile/presentation/providers/profile_controller.dart';
import 'package:bookapp/features/profile/presentation/widgets/image_picker_bottom_sheet.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImageSection extends ConsumerWidget {
  const ProfileImageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(profileControllerProvider);
    final isUploading = ref.watch(isUploadingImageProvider);

    final photoUrl = profileAsync.maybeWhen(
      data: (user) => user.photoUrl,
      orElse: () => null,
    );

    return Column(
      children: [
        GestureDetector(
          onTap: isUploading ? null : () => _onTapImage(context, ref),
          child: SizedBox(
            width: 100.w,
            height: 100.w,
            child: Stack(
              children: [
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.antiAlias,
                  child: _buildAvatar(context, photoUrl),
                ),
                if (isUploading)
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                if (!isUploading)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: context.colors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: context.colors.onPrimary,
                        size: 16.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Gap(AppSpacing.lg.h),
        GestureDetector(
          onTap: isUploading ? null : () => _onTapImage(context, ref),
          child: Text(
            isUploading ? l10n.uploadingImage : l10n.changePicture,
            style: context.type.bodyLargeSemiBold.copyWith(
              color: isUploading ? context.colors.hint : context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, String? photoUrl) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: photoUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircleAvatar(
          radius: 50.r,
          backgroundColor: context.colors.primarySurface,
          child: Icon(Icons.person, size: 40.sp, color: context.colors.primary),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 50.r,
          backgroundColor: context.colors.primarySurface,
          child: Icon(Icons.person, size: 40.sp, color: context.colors.primary),
        ),
      );
    }
    return CircleAvatar(
      radius: 50.r,
      backgroundColor: context.colors.primarySurface,
      child: Icon(Icons.person, size: 40.sp, color: context.colors.primary),
    );
  }

  Future<void> _onTapImage(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;

    final File? file = await showModalBottomSheet<File>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ImagePickerBottomSheet(),
    );

    if (file == null) return;

    if (!context.mounted) return;

    final success = await ref
        .read(profileControllerProvider.notifier)
        .updateProfileImage(file);

    if (!context.mounted) return;

    if (success) {
      SnackbarUtils.showSuccess(context, l10n.imageUploadSuccess);
    } else {
      SnackbarUtils.showError(context, l10n.imageUploadFailed);
    }
  }
}