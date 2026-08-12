import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/features/home/domain/entities/author_entity.dart';
import 'authors_providers.dart';

final allAuthorsProvider = Provider<AsyncValue<List<AuthorEntity>>>((ref) {
  return ref.watch(authorsStreamProvider);
});
