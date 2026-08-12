import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/extensions/theme_ext.dart';
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
                Icon(Icons.error_outline, color: context.colors.error, size: 28),
                const SizedBox(height: 6),
                Text(
                  l10n.retryButton,
                  style: context.type.bodySmallBold.copyWith(color: context.colors.primary),
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
                style: context.type.bodyMediumRegular.copyWith(color: context.colors.body),
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
