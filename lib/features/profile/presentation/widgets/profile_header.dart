import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/profile/presentation/providers/profile_controller.dart';
import 'package:bookapp/features/profile/presentation/widgets/logout_bottom_sheet.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(profileControllerProvider);

    final name = profileAsync.maybeWhen(
      data: (user) => user.name.isNotEmpty ? user.name : 'User',
      orElse: () => 'User',
    );
    final email = profileAsync.maybeWhen(
      data: (user) => user.email.isNotEmpty ? user.email : '',
      orElse: () => '',
    );
    final photoUrl = profileAsync.maybeWhen(
      data: (user) => user.photoUrl,
      orElse: () => null,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePadding.w,
        vertical: AppSpacing.lg.h,
      ),
      child: Row(
        children: [
          SizedBox(width: 56.w, height: 56.w, child: _buildAvatar(context, photoUrl)),
          Gap(AppSpacing.xxl.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.type.h6.copyWith(color: context.colors.title),
                ),
                Text(
                  email,
                  style: context.type.bodyMediumRegular.copyWith(
                    color: context.colors.body,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => const LogoutBottomSheet(),
              );
            },
            child: Text(
              l10n.logoutButton,
              style: context.type.bodyMediumBold.copyWith(
                color: context.colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String? photoUrl) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: photoUrl,
          fit: BoxFit.cover,
          width: 56.w,
          height: 56.w,
          placeholder: (context, url) => CircleAvatar(
            radius: 100.r,
            backgroundColor: context.colors.primarySurface,
            child: Icon(Icons.person, size: 24.sp, color: context.colors.primary),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: 100.r,
            backgroundColor: context.colors.primarySurface,
            child: Icon(Icons.person, size: 24.sp, color: context.colors.primary),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 100.r,
      backgroundColor: context.colors.primarySurface,
      child: Icon(Icons.person, size: 24.sp, color: context.colors.primary),
    );
  }
}