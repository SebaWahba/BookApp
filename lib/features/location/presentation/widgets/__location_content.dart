import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/location/domain/entities/address_entity.dart';
import 'package:bookapp/features/location/presentation/widgets/address_card.dart';
import 'package:bookapp/features/location/presentation/widgets/empty_addresses_state.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LocationContent extends StatelessWidget {
  const LocationContent({super.key, required this.addresses});

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
                ? EmptyAddressesState(
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
                        onTap: () =>
                            context.push(AppRoutes.newAddress, extra: address),
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
