import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'package:bookapp/features/home/presentation/vendors/views/vendors_list_view.dart';
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
          onSeeAllTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const VendorsListView(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        const VendorsSection(),
      ],
    );
  }
}
