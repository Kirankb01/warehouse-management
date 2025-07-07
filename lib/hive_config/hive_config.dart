import 'package:hive_flutter/adapters.dart';
import 'package:warehouse_management/models/app_settings.dart';
import 'package:warehouse_management/models/purchase.dart';
import 'package:warehouse_management/models/sale.dart';
import '../models/brand.dart';
import '../models/product.dart';
import '../models/user.dart';

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(BrandAdapter());
  Hive.registerAdapter(SaleAdapter());
  Hive.registerAdapter(SaleItemAdapter());
  Hive.registerAdapter(PurchaseAdapter());
  Hive.registerAdapter(AppSettingsAdapter());
  await Hive.openBox<Product>('productsBox');
  await Hive.openBox<User>('users');
  await Hive.openBox<Brand>('brandsBox');
  await Hive.openBox<Sale>('salesBox');
  await Hive.openBox<Purchase>('purchases');
  await Hive.openBox('authBox');
  await Hive.openBox<AppSettings>('app_settings');
}

