import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../vendors/providers/vendor_providers.dart';
import 'vendor_card.dart';

class VendorsSection extends ConsumerWidget {
  const VendorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final vendorsAsync = ref.watch(vendorsListProvider);

    return SizedBox(
      height: 80,
      child: vendorsAsync.when(
        loading: () => const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (error, _) => Center(
          child: GestureDetector(
            onTap: () => ref.invalidate(vendorsListProvider),
            child: const Icon(Icons.refresh, color: AppColors.red),
          ),
        ),
        data: (vendors) {
          if (vendors.isEmpty) {
            return Center(
              child: Text(
                l10n.noVendorsFound,
                style: const TextStyle(color: AppColors.vendorSubtleText),
              ),
            );
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: vendors.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              return VendorCard(
                logoPath: vendor.imagePath,
                vendorId: vendor.id,
                vendorName: vendor.name,
              );
            },
          );
        },
      ),
    );
  }
}
