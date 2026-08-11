import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/usecases/reverse_geocode_usecase.dart';
import 'location_providers.dart';
import 'location_state.dart';

class LocationController extends Notifier<LocationState> {
  // Default Cairo coordinates fallback if GPS fails or loading
  static const defaultFallbackLocation = LatLng(30.0444, 31.2357);

  @override
  LocationState build() {
    Future.microtask(() => initLocation());
    return const LocationState();
  }

  Future<void> initLocation() async {
    state = state.copyWith(isInitialLoading: true, clearErrorMessage: true);

    final checkPermissionUseCase = ref.read(checkLocationPermissionUseCaseProvider);
    final permissionResult = await checkPermissionUseCase();

    await permissionResult.fold(
      (failure) async {
        final errorMsg = failure.message.toLowerCase();
        final isPermanentlyDenied = errorMsg.contains('permanently denied');
        final isDisabled = errorMsg.contains('disabled');

        state = state.copyWith(
          isInitialLoading: false,
          permissionDenied: true,
          permissionDeniedForever: isPermanentlyDenied,
          locationServicesDisabled: isDisabled,
          selectedLocation: defaultFallbackLocation,
          errorMessage: failure.message,
        );

        await reverseGeocodePosition(defaultFallbackLocation);
      },
      (hasPermission) async {
        if (hasPermission) {
          final position = await fetchCurrentLocation();
          final target = position ?? defaultFallbackLocation;
          state = state.copyWith(
            isInitialLoading: false,
            currentGpsLocation: position,
            selectedLocation: target,
            permissionDenied: false,
            permissionDeniedForever: false,
            locationServicesDisabled: false,
          );
          await reverseGeocodePosition(target);
        } else {
          state = state.copyWith(
            isInitialLoading: false,
            permissionDenied: true,
            selectedLocation: defaultFallbackLocation,
          );
          await reverseGeocodePosition(defaultFallbackLocation);
        }
      },
    );
  }

  /// Fetches hardware GPS location and returns LatLng directly to caller.
  Future<LatLng?> fetchCurrentLocation() async {
    final getCurrentLocationUseCase =
        ref.read(getCurrentLocationUseCaseProvider);
    final locationResult = await getCurrentLocationUseCase();

    return locationResult.fold(
      (failure) {
        state = state.copyWith(
          errorMessage: failure.message,
        );
        return null;
      },
      (position) {
        final latLng = LatLng(position.latitude, position.longitude);
        state = state.copyWith(
          currentGpsLocation: latLng,
        );
        return latLng;
      },
    );
  }

  /// Triggered ONLY on Camera Idle to commit selected location and reverse geocode.
  Future<void> onCameraIdleCommitTarget(LatLng cameraTarget) async {
    state = state.copyWith(selectedLocation: cameraTarget);
    await reverseGeocodePosition(cameraTarget);
  }

  Future<void> reverseGeocodePosition(LatLng position) async {
    state = state.copyWith(isGeocoding: true);

    final reverseGeocodeUseCase = ref.read(reverseGeocodeUseCaseProvider);
    final result = await reverseGeocodeUseCase(
      ReverseGeocodeParams(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isGeocoding: false,
          formattedAddress:
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
        );
      },
      (formattedAddress) {
        state = state.copyWith(
          isGeocoding: false,
          formattedAddress: formattedAddress,
        );
      },
    );
  }

  void setAddressType(String type) {
    if (type == 'home' || type == 'office') {
      state = state.copyWith(addressType: type);
    }
  }

  Future<bool> saveSelectedAddress() async {
    if (!state.isConfirmEnabled || state.selectedLocation == null) {
      return false;
    }

    state = state.copyWith(isSaving: true, clearErrorMessage: true);

    final saveAddressUseCase = ref.read(saveAddressUseCaseProvider);
    final addressEntity = AddressEntity(
      id: state.addressType,
      latitude: state.selectedLocation!.latitude,
      longitude: state.selectedLocation!.longitude,
      formattedAddress: state.formattedAddress,
      addressType: state.addressType,
    );

    final result = await saveAddressUseCase(addressEntity);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isSaving: false);
        return true;
      },
    );
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}

final locationControllerProvider =
    NotifierProvider.autoDispose<LocationController, LocationState>(
  LocationController.new,
);
