import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/core/network/firestore_provider.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/datasources/location_service_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/check_location_permission_usecase.dart';
import '../../domain/usecases/get_current_location_usecase.dart';
import '../../domain/usecases/reverse_geocode_usecase.dart';
import '../../domain/usecases/save_address_usecase.dart';

// Data Sources
final locationRemoteDataSourceProvider = Provider<LocationRemoteDataSource>((ref) {
  return LocationRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
    auth: FirebaseAuth.instance,
  );
});

final locationServiceDataSourceProvider = Provider<LocationServiceDataSource>((ref) {
  return LocationServiceDataSourceImpl();
});

// Repository
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl(
    remoteDataSource: ref.watch(locationRemoteDataSourceProvider),
    serviceDataSource: ref.watch(locationServiceDataSourceProvider),
  );
});

// Use Cases
final checkLocationPermissionUseCaseProvider =
    Provider<CheckLocationPermissionUseCase>((ref) {
  return CheckLocationPermissionUseCase(ref.watch(locationRepositoryProvider));
});

final getCurrentLocationUseCaseProvider =
    Provider<GetCurrentLocationUseCase>((ref) {
  return GetCurrentLocationUseCase(ref.watch(locationRepositoryProvider));
});

final reverseGeocodeUseCaseProvider = Provider<ReverseGeocodeUseCase>((ref) {
  return ReverseGeocodeUseCase(ref.watch(locationRepositoryProvider));
});

final saveAddressUseCaseProvider = Provider<SaveAddressUseCase>((ref) {
  return SaveAddressUseCase(ref.watch(locationRepositoryProvider));
});
