import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'section_header.dart';
import 'top_of_week_section.dart';

class TopOfWeekGroup extends StatelessWidget {
  final AppLocalizations l10n;

  const TopOfWeekGroup({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.topOfWeek,
          onSeeAllTap: () {},
        ),
        const SizedBox(height: 16),
        const TopOfWeekSection(),
      ],
    );
  }
}
