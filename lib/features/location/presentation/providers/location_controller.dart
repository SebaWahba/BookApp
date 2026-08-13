import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/address_entity.dart';
import 'location_providers.dart';

class LocationController extends AsyncNotifier<List<AddressEntity>> {
  @override
  Future<List<AddressEntity>> build() async {
    return _fetchAddresses();
  }

  Future<List<AddressEntity>> _fetchAddresses() async {
    final result = await ref.read(getAddressesUseCaseProvider).call();
    return result.fold((failure) => throw failure, (addresses) => addresses);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchAddresses);
  }

  Future<bool> saveAddress({
    required String address,
    required String addressType,
  }) async {
    final trimmedAddress = address.trim();
    final normalizedType = addressType.toLowerCase();

    if (trimmedAddress.isEmpty) return false;
    if (normalizedType != 'home' && normalizedType != 'office') return false;

    final previousAddresses = state.value ?? const <AddressEntity>[];
    state = const AsyncValue.loading();

    final savedAddress = AddressEntity(
      id: normalizedType,
      address: trimmedAddress,
      addressType: normalizedType,
    );

    final saveResult = await ref
        .read(saveAddressUseCaseProvider)
        .call(savedAddress);

    return saveResult.fold(
      (failure) {
        state = AsyncValue.data(previousAddresses);
        return false;
      },
      (_) {
        // Optimistically update the local list instead of re-fetching.
        // Since id == normalizedType, this is an upsert: replace existing
        // entry with the same id, or append if it's new.
        final updated = [
          for (final a in previousAddresses)
            if (a.id == savedAddress.id) savedAddress else a,
        ];
        if (!updated.any((a) => a.id == savedAddress.id)) {
          updated.add(savedAddress);
        }
        state = AsyncValue.data(updated);
        return true;
      },
    );
  }
}

final locationControllerProvider =
    AsyncNotifierProvider<LocationController, List<AddressEntity>>(
      LocationController.new,
    );
