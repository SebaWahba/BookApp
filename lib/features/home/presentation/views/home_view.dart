import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/app_assets.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../../core/error/failure.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/home_controller.dart';
import '../widgets/author_card.dart';
import '../widgets/book_card.dart';
import '../widgets/home_bottom_bar.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/special_offer_banner.dart';
import '../widgets/vendor_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final booksAsync = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: HomeBottomBar(
        currentTab: BottomNavTab.home,
        onTabTap: (tab) {},
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeTopBar(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const SpecialOfferBanner(),
                      const SizedBox(height: 24),
                      SectionHeader(title: l10n.topOfWeek, onSeeAllTap: null),
                      const SizedBox(height: 16),
                      _buildTopOfWeek(booksAsync, l10n, ref),
                      const SizedBox(height: 24),
                      SectionHeader(title: l10n.bestVendors, onSeeAllTap: null),
                      const SizedBox(height: 16),
                      _buildVendors(),
                      const SizedBox(height: 24),
                      SectionHeader(title: l10n.authors, onSeeAllTap: null),
                      const SizedBox(height: 16),
                      _buildAuthors(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopOfWeek(AsyncValue booksAsync, AppLocalizations l10n, WidgetRef ref) {
    return SizedBox(
      height: 200,
      child: booksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error is Failure ? error.message : l10n.errorPrefix,
                style: AppTextStyles.bodyMediumRegular,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(homeControllerProvider),
                child: Text(l10n.retryButton),
              ),
            ],
          ),
        ),
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Text(l10n.noBooksFound, style: AppTextStyles.bodyMediumRegular),
            );
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => BookCard(book: books[index]),
          );
        },
      ),
    );
  }

  Widget _buildVendors() {
    final vendors = [
      AppAssets.vendorWarehouseStationery,
      AppAssets.vendorKuromi,
      AppAssets.vendorGooday,
      AppAssets.vendorCraneCo,
    ];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: vendors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) => VendorCard(logoPath: vendors[index]),
      ),
    );
  }

  Widget _buildAuthors() {
    final authors = [
      (AppAssets.authorJohnFreeman, 'John Freeman', 'Writer'),
      (AppAssets.authorTessGunty, 'Tess Gunty', 'Novelist'),
      (AppAssets.authorRichardPerston, 'Richard Perston', 'Writer'),
    ];

    return SizedBox(
      height: 183,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: authors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) => AuthorCard(
          imagePath: authors[index].$1,
          name: authors[index].$2,
          role: authors[index].$3,
        ),
      ),
    );
  }
}