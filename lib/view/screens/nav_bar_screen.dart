import 'package:flutter/material.dart';
import 'package:warehouse_management/Screens/dashboard_screen.dart';
import 'package:warehouse_management/Screens/items_screen.dart';
import 'package:warehouse_management/Screens/history_screen.dart';
import 'package:warehouse_management/Screens/selling_screen.dart';
import 'package:warehouse_management/Screens/settings_screen.dart';
import 'package:warehouse_management/constants/app_colors.dart';


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
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentIndex= 2;
          });
        },
        shape: CircleBorder(),
        backgroundColor: AppColors.primary,
        child: Icon(Icons.sync_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 60,
        color: AppColors.pureWhite,
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
                setState(() {
                  currentIndex= 4;
                });
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
