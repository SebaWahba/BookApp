import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/search/presentation/providers/search_provider.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchErrorState extends ConsumerWidget {
  final Object error;
  final String query;

  const SearchErrorState({super.key, required this.error, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: context.colors.hint,
            ),
            const Gap(AppSpacing.lg),
            Text(
              l10n.somethingWentWrong,
              style: context.type.h5.copyWith(color: context.colors.title),
            ),
            const Gap(AppSpacing.sm),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: context.type.bodySmallRegular.copyWith(color: context.colors.body),
            ),
            const Gap(AppSpacing.xxl),
            ElevatedButton(
              onPressed: () {
                ref.read(searchProvider.notifier).search(query);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}