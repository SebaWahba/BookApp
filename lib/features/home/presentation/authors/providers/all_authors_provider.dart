import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookapp/core/usecases/usecase.dart';
import 'package:bookapp/features/home/domain/entities/author_entity.dart';
import 'package:bookapp/features/home/domain/usecases/get_authors_usecase.dart';
import 'authors_providers.dart';

final getAuthorsUseCaseProvider = Provider<GetAuthorsUseCase>((ref) {
  final repository = ref.watch(authorRepositoryProvider);
  return GetAuthorsUseCase(repository);
});

final allAuthorsProvider = FutureProvider<List<AuthorEntity>>((ref) async {
  final useCase = ref.watch(getAuthorsUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.fold((failure) => throw failure, (authors) => authors);
});
