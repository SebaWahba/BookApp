import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/themes/app_colors.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/components/inputs/search_text_field.dart';
import '../../../../../core/responsive/app_breakpoints.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../providers/authors_providers.dart';
import '../widgets/author_list_item.dart';
import '../widgets/authors_header_titles.dart';
import '../widgets/authors_list_shimmer.dart';
import '../widgets/category_tabs_selector.dart';

class AuthorsScreen extends ConsumerStatefulWidget {
  const AuthorsScreen({super.key});

  @override
  ConsumerState<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends ConsumerState<AuthorsScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAuthorsAsync = ref.watch(filteredAuthorsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isTablet = MediaQuery.sizeOf(context).width >= AppBreakpoints.mobile;
    final maxContentWidth = isTablet ? 1000.0 : double.infinity;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.grey900, size: 22),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: _isSearching
            ? SearchTextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (val) {
            ref.read(authorSearchQueryProvider.notifier).setQuery(val);
          },
        )
            : Text(
          'Authors',
          style: AppTextStyles.h5.copyWith(color: isDark ? Colors.white : null),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: isDark ? Colors.white : AppColors.grey900,
              size: AppSpacing.xl,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  ref.read(authorSearchQueryProvider.notifier).setQuery('');
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Extracted Header Titles Widget
                const AuthorsHeaderTitles(),
                const SizedBox(height: AppSpacing.xs),

                // Extracted Horizontal Category Tabs Selector Widget
                const CategoryTabsSelector(),
                const SizedBox(height: AppSpacing.lg),

                // Authors List Stream
                Expanded(
                  child: filteredAuthorsAsync.when(
                    data: (authors) {
                      if (authors.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person_off_outlined, size: 64, color: AppColors.grey400),
                              const SizedBox(height: AppSpacing.lg),
                              Text(
                                'No authors found',
                                style: AppTextStyles.h4.copyWith(color: isDark ? Colors.grey[400] : AppColors.grey500),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                          vertical: AppSpacing.xs,
                        ),
                        itemCount: authors.length,
                        itemBuilder: (context, index) {
                          final author = authors[index];
                          return AuthorListItem(author: author);
                        },
                      );
                    },
                    loading: () => const AuthorsListShimmer(),
                    error: (error, stackTrace) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Text(
                          'Error loading authors: $error',
                          style: AppTextStyles.bodyMediumRegular.copyWith(color: isDark ? Colors.white : null),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}