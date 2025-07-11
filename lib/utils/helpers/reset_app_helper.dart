import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/route_constants.dart';
import 'package:warehouse_management/models/app_settings.dart';
import 'package:warehouse_management/models/brand.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/models/purchase.dart';
import 'package:warehouse_management/models/sale.dart';
import 'package:warehouse_management/models/user.dart';
import 'package:warehouse_management/viewmodel/login_view_model.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';
import 'package:warehouse_management/viewmodel/sales_provider.dart';
import 'package:warehouse_management/viewmodel/summary_view_model.dart';
import 'package:warehouse_management/viewmodel/theme_provider.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';
import 'package:warehouse_management/viewmodel/organization_profile_view_model.dart';

Future<void> resetAppData(BuildContext context) async {

  try {
    await Hive.box<Product>('productsBox').clear();
    await Hive.box<Sale>('salesBox').clear();
    await Hive.box<Brand>('brandsBox').clear();
    await Hive.box<AppSettings>('app_settings').clear();
    await Hive.box<User>('users').clear();
    await Hive.box('authBox').clear();
    await Hive.box<Purchase>('purchases').clear();

    Provider.of<ProductProvider>(context, listen: false).clearAll();
    Provider.of<SalesProvider>(context, listen: false).clearAllSales();
    Provider.of<ThemeProvider>(context, listen: false).resetToDefault();
    Provider.of<BrandProvider>(context, listen: false).clearAll();
    Provider.of<OrganizationProfileViewModel>(context, listen: false).reset();
    Provider.of<LoginViewModel>(context, listen: false).reset();
    Provider.of<SummaryViewModel>(context, listen: false).reset();

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.login,
          (route) => false,
    );
  } catch (e, stack) {
    print("RESET FAILED: $e\n$stack");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reset failed: $e")),
    );
  }
}






