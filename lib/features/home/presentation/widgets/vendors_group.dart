import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import 'section_header.dart';
import 'vendors_section.dart';

class VendorsGroup extends StatelessWidget {
  final AppLocalizations l10n;

  const VendorsGroup({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.bestVendors,
          onSeeAllTap: () => context.push(AppRoutes.vendors),
        ),
        const SizedBox(height: 16),
        const VendorsSection(),
      ],
    );
  }
}
