import 'dart:async';

import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/home/domain/usecases/search_books_usecase.dart';
import 'package:bookapp/features/home/presentation/providers/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// ─── State 

class SearchState {
  final String query;
  final AsyncValue<List<BookModel>> results;

  const SearchState({
    this.query = '',
    this.results = const AsyncValue.data([]),
  });

  SearchState copyWith({String? query, AsyncValue<List<BookModel>>? results}) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
    );
  }
}

// ─── Notifier 

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchBooksUseCase _searchUseCase;
  Timer? _debounce;

  SearchNotifier(this._searchUseCase) : super(const SearchState());

  void search(String query) {
    _debounce?.cancel();
    state = state.copyWith(query: query);

    if (query.trim().isEmpty) {
      state = state.copyWith(results: const AsyncValue.data([]));
      return;
    }

    state = state.copyWith(results: const AsyncValue.loading());

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final result = await _searchUseCase(query.trim());
      if (!mounted) return;
      state = state.copyWith(
        results: result.fold(
          (failure) => AsyncValue.error(failure.message, StackTrace.current),
          (books) => AsyncValue.data(books),
        ),
      );
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

// ─── Provider 

final searchProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
      return SearchNotifier(ref.watch(searchBooksUseCaseProvider));
    });
