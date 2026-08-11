import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationState {
  final LatLng? currentGpsLocation;
  final LatLng? selectedLocation;
  final String formattedAddress;
  final String addressType; // 'home' or 'office'
  final bool isInitialLoading;
  final bool isGeocoding;
  final bool isSaving;
  final bool permissionDenied;
  final bool permissionDeniedForever;
  final bool locationServicesDisabled;
  final String? errorMessage;

  const LocationState({
    this.currentGpsLocation,
    this.selectedLocation,
    this.formattedAddress = '',
    this.addressType = 'home',
    this.isInitialLoading = true,
    this.isGeocoding = false,
    this.isSaving = false,
    this.permissionDenied = false,
    this.permissionDeniedForever = false,
    this.locationServicesDisabled = false,
    this.errorMessage,
  });

  bool get isConfirmEnabled =>
      selectedLocation != null &&
      formattedAddress.isNotEmpty &&
      !isSaving &&
      !isGeocoding &&
      !isInitialLoading;

  LocationState copyWith({
    LatLng? currentGpsLocation,
    LatLng? selectedLocation,
    String? formattedAddress,
    String? addressType,
    bool? isInitialLoading,
    bool? isGeocoding,
    bool? isSaving,
    bool? permissionDenied,
    bool? permissionDeniedForever,
    bool? locationServicesDisabled,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LocationState(
      currentGpsLocation: currentGpsLocation ?? this.currentGpsLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      addressType: addressType ?? this.addressType,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isGeocoding: isGeocoding ?? this.isGeocoding,
      isSaving: isSaving ?? this.isSaving,
      permissionDenied: permissionDenied ?? this.permissionDenied,
      permissionDeniedForever:
          permissionDeniedForever ?? this.permissionDeniedForever,
      locationServicesDisabled:
          locationServicesDisabled ?? this.locationServicesDisabled,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
