import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/components/buttons/primary_button.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/failure.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/address_entity.dart';
import '../providers/location_controller.dart';
import '../widgets/address_card.dart';

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
        error: (error, _) => _LocationErrorState(
          message: error is Failure
              ? error.message
              : l10n.failedToLoadAddresses,
          onRetry: () => ref.invalidate(locationControllerProvider),
        ),
        data: (addresses) => _LocationContent(addresses: addresses),
      ),
    );
  }
}

class _LocationContent extends StatelessWidget {
  const _LocationContent({required this.addresses});

  final List<AddressEntity> addresses;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: addresses.isEmpty
                ? _EmptyAddressesState(
                    onNewAddress: () => context.push(AppRoutes.newAddress),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl.h),
                    itemCount: addresses.length,
                    separatorBuilder: (_, _) =>
                        SizedBox(height: AppSpacing.lg.h),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return AddressCard(
                        address: address,
                        title: address.addressType == 'office'
                            ? l10n.office
                            : l10n.home,
                        onTap: () => context.push(
                          AppRoutes.newAddress,
                          extra: address,
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
              child: PrimaryButton(
                text: l10n.newAddress,
                onPressed: () => context.push(AppRoutes.newAddress),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyAddressesState extends StatelessWidget {
  const _EmptyAddressesState({required this.onNewAddress});

  final VoidCallback onNewAddress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96.r,
            height: 96.r,
            decoration: const BoxDecoration(
              color: AppColors.primary100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_off_rounded,
              color: AppColors.primary400,
              size: 48.r,
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Text(
            l10n.noSavedAddresses,
            style: AppTextStyles.h5.copyWith(color: AppColors.grey700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xl.h),
          SizedBox(
            width: 220.w,
            child: PrimaryButton(
              text: l10n.newAddress,
              onPressed: onNewAddress,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationErrorState extends StatelessWidget {
  const _LocationErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: AppTextStyles.bodyMediumRegular.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm.h),
            TextButton(onPressed: onRetry, child: Text(l10n.retryButton)),
          ],
        ),
      ),
    );
  }
}
