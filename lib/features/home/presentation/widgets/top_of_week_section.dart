import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../providers/home_controller.dart';
import 'book_card.dart';
import 'book_card_shimmer.dart';

class TopOfWeekSection extends ConsumerWidget {
  const TopOfWeekSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final booksAsync = ref.watch(homeControllerProvider);

    return SizedBox(
      height: 200,
      child: booksAsync.when(
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) => const BookCardShimmer(),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error is Failure ? error.message : l10n.errorPrefix,
                style: AppTextStyles.bodyMediumRegular,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(homeControllerProvider),
                child: Text(l10n.retryButton),
              ),
            ],
          ),
        ),
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Text(
                l10n.noBooksFound,
                style: AppTextStyles.bodyMediumRegular,
              ),
            );
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => BookCard(book: books[index]),
          );
        },
      ),
    );
  }
}