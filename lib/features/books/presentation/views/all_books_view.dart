import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/features/books/presentation/providers/all_books_provider.dart';
import 'package:bookapp/features/books/presentation/widgets/books_empty_state.dart';
import 'package:bookapp/features/books/presentation/widgets/books_error_state.dart';
import 'package:bookapp/features/books/presentation/widgets/books_grid.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllBooksView extends ConsumerStatefulWidget {
  const AllBooksView({super.key});

  @override
  ConsumerState<AllBooksView> createState() => _AllBooksViewState();
}

class _AllBooksViewState extends ConsumerState<AllBooksView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_loadMoreWhenNeeded);
  }

  void _loadMoreWhenNeeded() {
    if (_scrollController.position.extentAfter < 300) {
      ref.read(allBooksControllerProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadMoreWhenNeeded)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allBooksAsync = ref.watch(allBooksControllerProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l10n.books),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(allBooksControllerProvider.notifier).refresh();
        },
        child: allBooksAsync.when(
          loading: () =>
          const BooksGrid(books: [], isLoading: true, isLoadingMore: false),
          error: (error, _) => BooksErrorState(
            message: error is Failure ? error.message : l10n.errorPrefix,
            retryLabel: l10n.retryButton,
            onRetry: () => ref.invalidate(allBooksControllerProvider),
          ),
          data: (state) {
            if (state.books.isEmpty) {
              return BooksEmptyState(message: l10n.noBooksFound);
            }

            return BooksGrid(
              books: state.books,
              isLoading: false,
              isLoadingMore: state.isLoadingMore,
              controller: _scrollController,
            );
          },
        ),
      ),
    );
  }
}