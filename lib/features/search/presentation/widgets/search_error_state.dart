import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/search/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchErrorState extends ConsumerWidget {
  final Object error;
  final String query;

  const SearchErrorState({
    super.key,
    required this.error,
    required this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: AppColors.grey400,
            ),
            const Gap(AppSpacing.lg),
            Text(
              'Something went wrong',
              style: AppTextStyles.h5.copyWith(
                color: AppColors.grey700,
              ),
            ),
            const Gap(AppSpacing.sm),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmallRegular.copyWith(
                color: AppColors.grey500,
              ),
            ),
            const Gap(AppSpacing.xxl),
            ElevatedButton(
              onPressed: () {
                ref.read(searchProvider.notifier).search(query);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary600,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}