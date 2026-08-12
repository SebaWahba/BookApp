import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../authors/providers/authors_providers.dart';
import '../authors/views/author_detail_screen.dart';
import 'author_card.dart';

class AuthorsSection extends ConsumerWidget {
  const AuthorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authorsAsync = ref.watch(authorsStreamProvider);

    return SizedBox(
      height: 160,
      child: authorsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: GestureDetector(
            onTap: () => ref.invalidate(authorsStreamProvider),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.red, size: 28),
                const SizedBox(height: 6),
                Text(
                  l10n.retryButton,
                  style: AppTextStyles.bodySmallBold.copyWith(
                    color: AppColors.primary500,
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (authors) {
          if (authors.isEmpty) {
            return Center(
              child: Text(
                l10n.noAuthorsFound,
                style: AppTextStyles.bodyMediumRegular,
              ),
            );
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: authors.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final author = authors[index];
              return AuthorCard(
                imageUrl: author.imageUrl,
                name: author.name,
                role: author.jobTitle,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AuthorDetailScreen(author: author),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
