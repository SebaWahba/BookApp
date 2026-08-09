import 'package:bookapp/core/components/inputs/search_text_field.dart';
import 'package:bookapp/features/search/presentation/providers/search_provider.dart';
import 'package:bookapp/features/search/presentation/widgets/search_empty_state.dart';
import 'package:bookapp/features/search/presentation/widgets/search_error_state.dart';
import 'package:bookapp/features/search/presentation/widgets/search_loading_grid.dart';
import 'package:bookapp/features/search/presentation/widgets/search_results_grid.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: SearchTextField(
          controller: _controller,
          onChanged: (query) {
            ref.read(searchProvider.notifier).search(query);
          },
          autofocus: true,
          hintText: l10n.searchForBooksTitle,
        ),
      ),
      body: searchState.results.when(
        data: (books) {
          if (searchState.query.trim().isEmpty) {
            return const SearchEmptyState(isInitial: true);
          }
          if (books.isEmpty) {
            return const SearchEmptyState(isInitial: false);
          }
          return SearchResultsGrid(books: books);
        },
        loading: () => const SearchLoadingGrid(),
        error: (error, _) =>
            SearchErrorState(error: error, query: searchState.query),
      ),
    );
  }
}