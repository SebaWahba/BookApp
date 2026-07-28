import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import 'authors_section.dart';
import 'section_header.dart';

class AuthorsGroup extends StatelessWidget {
  final AppLocalizations l10n;

  const AuthorsGroup({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.authors,
          onSeeAllTap: () => context.push(AppRoutes.authors),
        ),
        const SizedBox(height: 16),
        const AuthorsSection(),
      ],
    );
  }
}