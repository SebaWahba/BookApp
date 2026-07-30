import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/app_assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/theme_provider.dart';
import 'author_card.dart';

class AuthorsSection extends ConsumerWidget {
  const AuthorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authors = [
      (AppAssets.authorJohnFreeman, 'John Freeman', l10n.writer),
      (AppAssets.authorTessGunty, 'Tess Gunty', l10n.novelist),
      (AppAssets.authorRichardPerston, 'Richard Perston', l10n.writer),
    ];

    return SizedBox(
      height: 183,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: authors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) => AuthorCard(
          imagePath: authors[index].$1,
          name: authors[index].$2,
          role: authors[index].$3,
        ),
      ),
    );
  }
}