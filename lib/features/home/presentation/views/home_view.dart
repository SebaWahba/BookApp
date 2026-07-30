import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/home_controller.dart';
import '../widgets/authors_group.dart';
import '../widgets/home_bottom_bar.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/special_offer_banner.dart';
import '../widgets/top_of_week_group.dart';
import '../widgets/vendors_group.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: HomeBottomBar(
        currentTab: BottomNavTab.home,
        onTabTap: (tab) {},
      ),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            final error =
            await ref.read(homeControllerProvider.notifier).refresh();
            if (error != null && context.mounted) {
              SnackbarUtils.showError(
                context,
                error is Failure ? error.message : l10n.errorPrefix,
              );
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ResponsiveBuilder(
              mobile: (context) => _buildLayout(context, l10n, padding: 24),
              tablet: (context) =>
                  _buildLayout(context, l10n, padding: 32, maxWidth: 900),
              desktop: (context) => _buildDesktopLayout(context, l10n),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayout(
      BuildContext context,
      AppLocalizations l10n, {
        required double padding,
        double? maxWidth,
      }) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeTopBar(onSearchTap: () => context.push(AppRoutes.search)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: _MainHomeContent(l10n: l10n),
        ),
      ],
    );

    if (maxWidth != null) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: content,
        ),
      );
    }
    return content;
  }

  Widget _buildDesktopLayout(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeTopBar(onSearchTap: () => context.push(AppRoutes.search)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const SpecialOfferBanner(),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TopOfWeekGroup(l10n: l10n),
                            const SizedBox(height: 32),
                            VendorsGroup(l10n: l10n),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        flex: 2,
                        child: AuthorsGroup(l10n: l10n),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainHomeContent extends StatelessWidget {
  final AppLocalizations l10n;
  const _MainHomeContent({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const SpecialOfferBanner(),
        const SizedBox(height: 24),
        TopOfWeekGroup(l10n: l10n),
        const SizedBox(height: 24),
        VendorsGroup(l10n: l10n),
        const SizedBox(height: 24),
        AuthorsGroup(l10n: l10n),
        const SizedBox(height: 32),
      ],
    );
  }
}