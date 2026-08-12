import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/products_remote_datasource.dart';
import '../../../data/datasources/products_remote_datasource_impl.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/products_repository_impl.dart';
import '../../../domain/repositories/products_repository.dart';

/// Provider for ProductsRemoteDataSource
final productsRemoteDataSourceProvider = Provider<ProductsRemoteDataSource>((ref) {
  return ProductsRemoteDataSourceImpl(FirebaseFirestore.instance);
});

/// Provider for ProductsRepository
final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final dataSource = ref.watch(productsRemoteDataSourceProvider);
  return ProductsRepositoryImpl(dataSource);
});

/// Notifier handling the active category filter tab
class SelectedCategoryFilterNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setCategory(String category) => state = category;
}

final selectedCategoryFilterProvider =
    NotifierProvider<SelectedCategoryFilterNotifier, String>(
        SelectedCategoryFilterNotifier.new);

/// StreamProvider fetching real-time products based on active category filter
final categoryProductsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  final repository = ref.watch(productsRepositoryProvider);
  final category = ref.watch(selectedCategoryFilterProvider);
  return repository.getProductsStream(category: category);
});
