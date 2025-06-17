import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:warehouse_management/app.dart';
import 'package:warehouse_management/hive_config/hive_config.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';
import 'package:warehouse_management/viewmodel/sales_provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupHive();

  final box = Hive.box('authBox');
  final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),

      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}








