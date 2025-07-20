import 'package:flutter/material.dart';
import 'package:warehouse_management/view/app.dart';
import 'package:warehouse_management/hive_config/hive_config.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';
import 'package:warehouse_management/viewmodel/login_view_model.dart';
import 'package:warehouse_management/viewmodel/organization_profile_view_model.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';
import 'package:warehouse_management/viewmodel/sales_provider.dart';
import 'package:warehouse_management/viewmodel/summary_view_model.dart';
import 'package:warehouse_management/viewmodel/theme_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => SummaryViewModel()),
        ChangeNotifierProvider(create: (_) => OrganizationProfileViewModel()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadThemeFromHive(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => const MyApp(),
      ),
    ),
  );
}
