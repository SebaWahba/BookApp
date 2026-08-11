import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/components/buttons/primary_button.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/location_controller.dart';
import '../widgets/address_detail_card.dart';
import '../widgets/address_type_selector.dart';
import '../widgets/center_pin_widget.dart';
import '../widgets/map_widget.dart';

class LocationView extends ConsumerStatefulWidget {
  const LocationView({super.key});

  @override
  ConsumerState<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends ConsumerState<LocationView> {
  GoogleMapController? _mapController;
  bool _isMovingMap = false;

  void _animateToPosition(LatLng position) {
    _mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(locationControllerProvider);
    final controller = ref.read(locationControllerProvider.notifier);

    ref.listen(locationControllerProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.red,
          ),
        );
      }
    });

    final initialCenter =
        state.selectedLocation ??
        state.currentGpsLocation ??
        LocationController.defaultFallbackLocation;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.locationTitle,
          style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
        ),
      ),
      body: state.isInitialLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            )
          : Stack(
              children: [
                // 1. Google Map Container
                Positioned.fill(
                  child: MapWidget(
                    initialPosition: initialCenter,
                    isPermissionGranted: !state.permissionDenied,
                    onMapCreated: (mapCtrl) {
                      _mapController = mapCtrl;
                    },
                    onMovingStateChanged: (isMoving) {
                      if (_isMovingMap != isMoving) {
                        setState(() {
                          _isMovingMap = isMoving;
                        });
                      }
                    },
                    onCameraIdleTarget: (committedTarget) {
                      controller.onCameraIdleCommitTarget(committedTarget);
                    },
                  ),
                ),

                // 2. Visually Fixed Center Pin
                Positioned(
                  top: 0,
                  bottom: 180.h,
                  left: 0,
                  right: 0,
                  child: Center(child: CenterPinWidget(isMoving: _isMovingMap)),
                ),

                // 3. Permission / Service Banner
                if (state.permissionDeniedForever ||
                    state.locationServicesDisabled)
                  Positioned(
                    top: 16.h,
                    left: 16.w,
                    right: 16.w,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.white,
                      child: Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_off_rounded,
                              color: AppColors.red,
                              size: 24.r,
                            ),
                            Gap(8.w),
                            Expanded(
                              child: Text(
                                state.locationServicesDisabled
                                    ? l10n.locationServicesDisabled
                                    : l10n.locationPermissionDenied,
                                style: AppTextStyles.bodySmallRegular.copyWith(
                                  color: AppColors.grey800,
                                ),
                              ),
                            ),
                            if (state.permissionDeniedForever)
                              TextButton(
                                onPressed: () => controller.openAppSettings(),
                                child: Text(l10n.openSettings),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // 4. Bottom Address Details Sheet & Actions
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.pagePadding.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowGrey.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AddressDetailCard(
                            title: l10n.detailAddressTitle,
                            addressText: state.formattedAddress,
                            isLoading: state.isGeocoding,
                            onCurrentLocationPressed: () async {
                              LatLng? target = state.currentGpsLocation;
                              target ??= await controller
                                  .fetchCurrentLocation();

                              if (target != null) {
                                _animateToPosition(target);
                                await controller.onCameraIdleCommitTarget(
                                  target,
                                );
                              }
                            },
                          ),
                          Gap(AppSpacing.lg.h),
                          AddressTypeSelector(
                            title: l10n.addressTypeTitle,
                            homeLabel: l10n.homeType,
                            officeLabel: l10n.officeType,
                            selectedType: state.addressType,
                            onTypeSelected: (type) =>
                                controller.setAddressType(type),
                          ),
                          Gap(AppSpacing.xl.h),
                          PrimaryButton(
                            text: state.isSaving
                                ? l10n.savingButton
                                : l10n.confirmAddressButton,
                            onPressed: state.isConfirmEnabled
                                ? () async {
                                    final success = await controller
                                        .saveSelectedAddress();
                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.addressSavedSuccess,
                                          ),
                                          backgroundColor: AppColors.green,
                                        ),
                                      );
                                      context.pop();
                                    }
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
