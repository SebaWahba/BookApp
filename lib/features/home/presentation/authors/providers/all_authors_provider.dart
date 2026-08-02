import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/core/network/firestore_provider.dart';
import 'package:bookapp/core/usecases/usecase.dart';
import 'package:bookapp/features/home/data/datasources/authors_remote_datasource.dart';
import 'package:bookapp/features/home/data/repositories/authors_repository_impl.dart';
import 'package:bookapp/features/home/domain/entities/author_entity.dart';
import 'package:bookapp/features/home/domain/repositories/authors_repository.dart';
import 'package:bookapp/features/home/domain/usecases/get_authors_usecase.dart';

final authorsRemoteDataSourceProvider = Provider<AuthorsRemoteDataSource>((
  ref,
) {
  final firestore = ref.watch(firestoreProvider);
  return AuthorsRemoteDataSourceImpl(firestore);
});

final authorsRepositoryProvider = Provider<AuthorsRepository>((ref) {
  final dataSource = ref.watch(authorsRemoteDataSourceProvider);
  return AuthorsRepositoryImpl(dataSource);
});

final getAuthorsUseCaseProvider = Provider<GetAuthorsUseCase>((ref) {
  final repository = ref.watch(authorsRepositoryProvider);
  return GetAuthorsUseCase(repository);
});

final allAuthorsProvider = FutureProvider<List<AuthorEntity>>((ref) async {
  final useCase = ref.watch(getAuthorsUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.fold((failure) => throw failure, (authors) => authors);
});
