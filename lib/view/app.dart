import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/route_constants.dart';
import 'package:warehouse_management/view/dashboard_screen/notification_screen/screen/notification_screen.dart';
import 'package:warehouse_management/view/selling_screen/screens/selling_screen.dart';
import 'package:warehouse_management/view/login_signup_screen/login_screen/screen/login_screen.dart';
import 'package:warehouse_management/view/nav_bar_screen.dart';
import 'package:warehouse_management/view/on_board_screen/onboard_screen.dart';
import 'package:warehouse_management/view/settings_screens/account_details/screen/account_details.dart';
import 'package:warehouse_management/view/settings_screens/edit_account_details/screen/edit_account_details.dart';
import 'package:warehouse_management/view/settings_screens/privacy_policy/screen/privacy_policy.dart';
import 'package:warehouse_management/view/settings_screens/settings_screen/screen/settings_screen.dart';
import 'package:warehouse_management/view/settings_screens/user_manual/screen/user_manual_screen.dart';
import 'all_items_screen/item_screen/screen/items_screen.dart';
import 'login_signup_screen/sign_up_screen/screen/signup.dart';



class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.themeDataColor),
      ),
      initialRoute: isLoggedIn ? '/homepage' : '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        RouteNames.privacyPolicy: (context) => PrivacyPolicyPage(),
        RouteNames.signup: (context) => Signup(),
        RouteNames.homepage: (context) => BottomNavBar(),
        RouteNames.onBoard: (context) => OnboardingScreen(),
        RouteNames.login: (context) => LoginScreen(),
        RouteNames.allItems: (context) => ItemsScreen(),
        RouteNames.accountDetails: (context) => AccountDetails(),
        RouteNames.editAccountDetails: (context) => OrganizationProfileScreen(),
        RouteNames.notification: (context) => NotificationScreen(),
        RouteNames.userManual: (context) => UserManualScreen(),
        RouteNames.navBar: (context) => BottomNavBar(),
        RouteNames.sellingScreen: (context) => SellScreen(),
        RouteNames.settingsScreen: (context) => SettingsScreen(),
      },
    );
  }
}