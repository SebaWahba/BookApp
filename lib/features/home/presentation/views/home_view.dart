import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/theme_provider.dart';
import '../../../vendors/presentation/views/vendors_list_view.dart';
import '../providers/home_controller.dart';
import '../widgets/authors_section.dart';
import '../widgets/home_bottom_bar.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/special_offer_banner.dart';
import '../widgets/top_of_week_section.dart';
import '../widgets/vendors_section.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : AppColors.white,
      bottomNavigationBar: HomeBottomBar(
        currentTab: BottomNavTab.home,
        onTabTap: (tab) {},
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            final error = await ref
                .read(homeControllerProvider.notifier)
                .refresh();
            if (error != null && context.mounted) {
              SnackbarUtils.showError(
                context,
                error is Failure ? error.message : l10n.errorPrefix,
              );
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeTopBar(
                  onSearchTap: () => context.push(AppRoutes.search),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const SpecialOfferBanner(),
                      const SizedBox(height: 24),

                      SectionHeader(
                        title: l10n.topOfWeek,
                        onSeeAllTap: () => context.push(AppRoutes.allBooks),
                      ),
                      const SizedBox(height: 16),
                      const TopOfWeekSection(),
                      const SizedBox(height: 24),

                      SectionHeader(
                        title: l10n.bestVendors,
                        onSeeAllTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const VendorsListView(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const VendorsSection(),
                      const SizedBox(height: 24),

                      SectionHeader(title: l10n.authors, onSeeAllTap: null),
                      const SizedBox(height: 16),
                      const AuthorsSection(),
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
}