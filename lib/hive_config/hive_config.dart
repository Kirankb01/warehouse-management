import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/product.dart';
import '../models/user.dart';

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Product>('productsBox');
  await Hive.openBox<User>('users');
  await Hive.openBox('authBox');
}

