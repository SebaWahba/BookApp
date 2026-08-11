import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationServiceDataSource {
  Future<bool> checkAndRequestPermission();
  Future<Position> getCurrentLocation();
  Future<String> reverseGeocode(double latitude, double longitude);
}

class LocationServiceDataSourceImpl implements LocationServiceDataSource {
  final Geocoding _geocoding = Geocoding();

  @override
  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    return true;
  }

  @override
  Future<Position> getCurrentLocation() async {
    await checkAndRequestPermission();
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    ).timeout(const Duration(seconds: 10));
  }

  @override
  Future<String> reverseGeocode(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await _geocoding.placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = <String>[
          if (place.street != null && place.street!.isNotEmpty) place.street!,
          if (place.subLocality != null && place.subLocality!.isNotEmpty)
            place.subLocality!,
          if (place.locality != null && place.locality!.isNotEmpty)
            place.locality!,
          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty)
            place.administrativeArea!,
          if (place.country != null && place.country!.isNotEmpty)
            place.country!,
        ];

        if (parts.isNotEmpty) {
          return parts.join(', ');
        }
      }
      return '$latitude, $longitude';
    } catch (_) {
      return '$latitude, $longitude';
    }
  }
}
