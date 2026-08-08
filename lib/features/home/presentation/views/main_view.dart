import 'package:flutter/material.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../vendors/views/vendors_list_view.dart';
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
      backgroundColor: AppColors.white,
      body: IndexedStack(
        index: _currentTab.index,
        children: const [
          HomeViewBody(),
          VendorsListView(),
          Center(child: Text('Cart View')),
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
