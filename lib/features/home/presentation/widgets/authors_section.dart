import 'package:flutter/material.dart';

import '../../../../config/app_assets.dart';
import 'author_card.dart';

class AuthorsSection extends StatelessWidget {
  const AuthorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final authors = [
      (AppAssets.authorJohnFreeman, 'John Freeman', 'Writer'),
      (AppAssets.authorTessGunty, 'Tess Gunty', 'Novelist'),
      (AppAssets.authorRichardPerston, 'Richard Perston', 'Writer'),
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