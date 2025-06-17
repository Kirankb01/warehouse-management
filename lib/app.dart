import 'package:flutter/material.dart';
import 'package:warehouse_management/Screens/items_screen.dart';
import 'package:warehouse_management/Screens/login_screen.dart';
import 'package:warehouse_management/view/screens/account_details.dart';
import 'package:warehouse_management/view/screens/edit_account_details.dart';
import 'package:warehouse_management/view/screens/nav_bar_screen.dart';
import 'package:warehouse_management/view/screens/notification_screen.dart';
import 'package:warehouse_management/view/screens/onboard_screen.dart';
import 'package:warehouse_management/view/screens/privacy_policy.dart';
import 'package:warehouse_management/view/screens/signup.dart';
import 'package:warehouse_management/view/screens/user_manual_screen.dart';



class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: isLoggedIn ? '/homepage' : '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/privacy_policy':(context)=>PrivacyPolicyPage(),
        '/signup': (context) => Signup(),
        '/homepage':(context)=>BottomNavBar(),
        '/on_board': (context) => OnBoardingPage(),
        '/login': (context) => LoginScreen(),
        '/allItems':(context)=>ItemsScreen(),
        '/account_details':(context)=>AccountDetails(),
        '/edit_account_details':(context)=>EditAccountDetails(),
        '/notification':(context)=>NotificationScreen(),
        '/user_manual':(context)=>UserManualScreen(),
        '/nav_bar':(context)=>BottomNavBar()
      },
    );
  }
}