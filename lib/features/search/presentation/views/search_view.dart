import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/features/home/presentation/widgets/book_card.dart';
import 'package:bookapp/features/home/presentation/widgets/book_card_shimmer.dart';
import 'package:bookapp/features/search/presentation/providers/search_provider.dart';
import 'package:bookapp/features/search/presentation/widgets/search_empty_state.dart';
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

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.grey800,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _SearchTextField(
          controller: _controller,
          onChanged: (query) => ref.read(searchProvider.notifier).search(query),
        ),
      ),
      body: searchState.results.when(
        data: (books) {
          // ── Initial state: query empty ──────────────────────────────────
          if (searchState.query.trim().isEmpty) {
            return const SearchEmptyState(isInitial: true);
          }

          // ── No results ──────────────────────────────────────────────────
          if (books.isEmpty) {
            return const SearchEmptyState(isInitial: false);
          }

          // ── Results grid ────────────────────────────────────────────────
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
              childAspectRatio: 127 / 190,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) => BookCard(book: books[index]),
          );
        },

        loading: () => GridView.builder(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: 127 / 190,
          ),
          itemCount: 6,
          itemBuilder: (_, __) => const BookCardShimmer(),
        ),

        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 56,
                  color: AppColors.grey400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: AppTextStyles.h5.copyWith(color: AppColors.grey700),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmallRegular.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref
                      .read(searchProvider.notifier)
                      .search(searchState.query),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary600,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Search TextField ─────────────────────────────────────────────────────────

class _SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchTextField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: true,
      style: AppTextStyles.bodyLargeRegular.copyWith(color: AppColors.grey900),
      decoration: InputDecoration(
        hintText: 'Search books, authors…',
        hintStyle: AppTextStyles.bodyLargeRegular.copyWith(
          color: AppColors.grey400,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: AppColors.grey500,
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
      ),
    );
  }
}
