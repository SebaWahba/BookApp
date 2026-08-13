import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/core/error/failure.dart';
import 'package:bookapp/core/responsive/app_breakpoints.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import '../providers/all_authors_provider.dart';
import '../widgets/authors_empty_state.dart';
import '../widgets/authors_error_state.dart';
import '../widgets/authors_grid.dart';

class AllAuthorsView extends ConsumerWidget {
  const AllAuthorsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authorsAsync = ref.watch(allAuthorsProvider);
    final isTablet = MediaQuery.sizeOf(context).width >= AppBreakpoints.mobile;
    final maxContentWidth = isTablet ? 700.0 : double.infinity;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.sp),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l10n.authors),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(allAuthorsProvider);
                await ref.read(allAuthorsProvider.future);
              },
              child: authorsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => AuthorsErrorState(
                  message: error is Failure
                      ? error.message
                      : l10n.errorLoadingAuthors,
                  retryLabel: l10n.retryButton,
                  onRetry: () => ref.invalidate(allAuthorsProvider),
                ),
                data: (authors) {
                  if (authors.isEmpty) {
                    return AuthorsEmptyState(message: l10n.noAuthorsFound);
                  }
                  return AuthorsGrid(authors: authors);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}