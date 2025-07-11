import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/all_items_screen/item_screen/screen/items_screen.dart';
import 'package:warehouse_management/view/dashboard_screen/dashboard_screen/screen/dashboard_screen.dart';
import 'package:warehouse_management/view/sales_purchase_history_screen/screens/history_screen.dart';
import 'package:warehouse_management/view/selling_screen/screens/selling_screen.dart';
import 'package:warehouse_management/view/settings_screens/settings_screen/screen/settings_screen.dart';
import '../../constants/route_constants.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  List screens =[
    const DashboardScreen(),
    ItemsScreen(),
    const SellScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeHelper.scaffoldBackground(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentIndex= 2;
          });
        },
        shape: CircleBorder(),
        backgroundColor: AppColors.primary,
        child: Icon(Icons.point_of_sale,color: AppColors.pureWhite,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 60,
        color: AppThemeHelper.dialogBackground(context),
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex= 0;
                });
              },
              icon: Icon(
                Icons.dashboard_outlined,
                size: 25,
                color: currentIndex == 0 ? AppColors.primary : Colors.grey.shade500,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex= 1;
                });
              },
              icon: Icon(
                Icons.category_outlined,
                size: 25,
                color: currentIndex == 1 ? AppColors.primary
                : Colors.grey.shade500,
              ),
            ),
            SizedBox(width: 15),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex= 3;
                });
              },
              icon: Icon(
                Icons.history,
                size: 25,
                color: currentIndex == 3 ? AppColors.primary
                : AppColors.navBarUnselected,
              ),
            ),
            IconButton(
              onPressed: () {
                // setState(() {
                //   currentIndex= 4;
                // });
                Navigator.pushNamed(context, RouteNames.settingsScreen);
              },
              icon: Icon(
                Icons.settings,
                size: 25,
                color: currentIndex == 4 ? AppColors.primary : AppColors.navBarUnselected,
              ),
            ),
          ],
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
