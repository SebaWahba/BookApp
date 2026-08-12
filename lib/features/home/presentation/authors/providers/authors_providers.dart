import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/authors_remote_datasource.dart';
import '../../../data/models/author_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/authors_repository_impl.dart';
import '../../../domain/repositories/authors_repository.dart';

final authorsRemoteDataSourceProvider = Provider<AuthorsRemoteDataSource>((ref) {
  return AuthorsRemoteDataSourceImpl(FirebaseFirestore.instance);
});

final authorRepositoryProvider = Provider<AuthorsRepository>((ref) {
  final dataSource = ref.watch(authorsRemoteDataSourceProvider);
  return AuthorsRepositoryImpl(dataSource);
});

final authorsRepositoryProvider = authorRepositoryProvider;

final authorsStreamProvider = StreamProvider<List<AuthorModel>>((ref) {
  final repository = ref.watch(authorRepositoryProvider);
  return repository.getAuthorsStream();
});

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setCategory(String category) => state = category;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(SelectedCategoryNotifier.new);

class AuthorSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final authorSearchQueryProvider =
    NotifierProvider<AuthorSearchQueryNotifier, String>(AuthorSearchQueryNotifier.new);

final filteredAuthorsProvider = Provider<AsyncValue<List<AuthorModel>>>((ref) {
  final authorsAsync = ref.watch(authorsStreamProvider);
  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(authorSearchQueryProvider).trim().toLowerCase();

  return authorsAsync.whenData((authors) {
    var filtered = authors;

    if (category != 'All') {
      filtered = filtered.where((author) {
        return author.jobTitle.toLowerCase().contains(category.toLowerCase());
      }).toList();
    }

    if (query.isNotEmpty) {
      filtered = filtered.where((author) {
        return author.name.toLowerCase().contains(query) ||
            author.jobTitle.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  });
});
final authorProductsProvider =
    StreamProvider.family<List<ProductModel>, String>((ref, authorId) {
  final repository = ref.watch(authorRepositoryProvider);
  return repository.getProductsByAuthorIdStream(authorId);
});
