import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../widgets/home_bottom_bar.dart';
import 'home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  BottomNavTab _currentTab = BottomNavTab.home;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          const HomeViewBody(),
          Center(child: Text(l10n.categoryViewTitle)),
          Center(child: Text(l10n.cartViewTitle)),
          const ProfileView(),
        ],
      ),
      bottomNavigationBar: HomeBottomBar(
        currentTab: _currentTab,
        onTabTap: (tab) {
          setState(() {
            _currentTab = tab;
          });
        },
      ),
    );
  }
}