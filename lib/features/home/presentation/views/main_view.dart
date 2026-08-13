import 'package:flutter/material.dart';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import '../../../profile/presentation/views/profile_view.dart';
import 'package:bookapp/features/cart/presentation/views/cart_view.dart';
import '../vendors/views/vendors_list_view.dart';
import '../category/views/category_view.dart';
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
    return Scaffold(
      backgroundColor: context.colors.background,
      body: IndexedStack(
        index: _currentTab.index,
        children: const [
          HomeViewBody(),
          CategoryView(),
          CartView(),
          ProfileView(),
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