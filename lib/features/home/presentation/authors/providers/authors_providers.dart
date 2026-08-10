import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/author_model.dart';
import '../../../data/models/product_model.dart';

/// StreamProvider fetching all authors from Firestore collection `authors`
final authorsStreamProvider = StreamProvider<List<AuthorModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('authors')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => AuthorModel.fromFirestore(doc))
        .toList();
  });
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

/// Computed Provider filtering authors by selected category and search query
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

/// StreamProvider.family fetching products for a specific authorId strictly from Firestore `products` collection
final authorProductsProvider =
    StreamProvider.family<List<ProductModel>, String>((ref, authorId) {
  return FirebaseFirestore.instance
      .collection('products')
      .where('authorId', isEqualTo: authorId)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc))
        .toList();
  });
});
