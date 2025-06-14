import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:warehouse_management/screens/items_screen.dart';
import 'package:warehouse_management/screens/account_details.dart';
import 'package:warehouse_management/screens/edit_account_details.dart';
import 'package:warehouse_management/screens/login_screen.dart';
import 'package:warehouse_management/screens/nav_bar_screen.dart';
import 'package:warehouse_management/screens/privacy_policy.dart';
import 'package:warehouse_management/screens/signup.dart';
import 'package:warehouse_management/screens/user_manual_screen.dart';
import 'package:warehouse_management/screens/notification_screen.dart';
import 'package:warehouse_management/screens/onboard_screen.dart';
import 'package:warehouse_management/hive_config/hive_config.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/providers/product_provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupHive();

  final box = Hive.box('authBox');
  final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}





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


