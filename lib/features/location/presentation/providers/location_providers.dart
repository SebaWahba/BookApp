import 'package:bookapp/features/location/data/datasources/location_remote_datasource_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/firebase_auth_provider.dart';
import '../../../../core/network/firestore_provider.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/save_address_usecase.dart';

final locationRemoteDataSourceProvider = Provider<LocationRemoteDataSource>(
  (ref) {
  return LocationRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl(ref.watch(locationRemoteDataSourceProvider));
});

final getAddressesUseCaseProvider = Provider<GetAddressesUseCase>((ref) {
  return GetAddressesUseCase(ref.watch(locationRepositoryProvider));
});

final saveAddressUseCaseProvider = Provider<SaveAddressUseCase>((ref) {
  return SaveAddressUseCase(ref.watch(locationRepositoryProvider));
});
