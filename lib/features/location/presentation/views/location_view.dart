import 'package:bookapp/features/location/presentation/widgets/__location_content.dart';
import 'package:bookapp/features/location/presentation/widgets/__location_error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/error/failure.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/location_controller.dart';

class LocationView extends ConsumerWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final addressesAsync = ref.watch(locationControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.locationTitle, style: AppTextStyles.h4)),
      body: addressesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => LocationErrorState(
          message: error is Failure
              ? error.message
              : l10n.failedToLoadAddresses,
          onRetry: () => ref.invalidate(locationControllerProvider),
        ),
        data: (addresses) => LocationContent(addresses: addresses),
      ),
    );
  }
}
