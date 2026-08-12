import 'package:bookapp/core/network/firestore_provider.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/my_favorite/data/datasources/favorites_remote_data_source.dart';
import 'package:bookapp/features/my_favorite/data/datasources/favorites_remote_datasource_impl.dart';
import 'package:bookapp/features/my_favorite/data/repositories/favorites_repository_impl.dart';
import 'package:bookapp/features/my_favorite/domain/repositories/favorites_repository.dart';
import 'package:bookapp/features/my_favorite/domain/usecases/add_favorite_usecase.dart';
import 'package:bookapp/features/my_favorite/domain/usecases/remove_favorite_usecase.dart';
import 'package:bookapp/features/my_favorite/domain/usecases/toggle_favorite_usecase.dart';
import 'package:bookapp/core/network/firebase_auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesRemoteDataSourceProvider = Provider<FavoritesRemoteDataSource>((
  ref,
) {
  return FavoritesRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.watch(favoritesRemoteDataSourceProvider));
});

final addFavoriteUseCaseProvider = Provider<AddFavoriteUseCase>((ref) {
  return AddFavoriteUseCase(ref.watch(favoritesRepositoryProvider));
});

final removeFavoriteUseCaseProvider = Provider<RemoveFavoriteUseCase>((ref) {
  return RemoveFavoriteUseCase(ref.watch(favoritesRepositoryProvider));
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>((ref) {
  return ToggleFavoriteUseCase(ref.watch(favoritesRepositoryProvider));
});

final favoriteBooksProvider = StreamProvider.autoDispose<List<BookModel>>((
  ref,
) {
  return ref.watch(favoritesRepositoryProvider).watchFavorites();
});

final isBookFavoriteProvider = StreamProvider.autoDispose.family<bool, String>((
  ref,
  bookId,
) {
  return ref.watch(favoritesRepositoryProvider).watchIsFavorite(bookId);
});

class FavoriteActionsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> add(BookModel book) async {
    state = const AsyncValue.loading();
    final result = await ref.read(addFavoriteUseCaseProvider).call(book);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> remove(String bookId) async {
    state = const AsyncValue.loading();
    final result = await ref.read(removeFavoriteUseCaseProvider).call(bookId);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> toggle(BookModel book) async {
    state = const AsyncValue.loading();
    final result = await ref.read(toggleFavoriteUseCaseProvider).call(book);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }
}

final favoriteActionsControllerProvider =
    AsyncNotifierProvider<FavoriteActionsController, void>(
      FavoriteActionsController.new,
    );
