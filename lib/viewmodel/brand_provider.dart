import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../models/brand.dart';

class BrandProvider extends ChangeNotifier {
  late Box<Brand> _brandBox;
  List<Brand> _brands = [];

  List<Brand> get brands => _brands;



  BrandProvider() {
    _brandBox = Hive.box<Brand>('brandsBox');
    loadBrands();
  }

  void loadBrands() {
    _brands = _brandBox.values.toList();
    notifyListeners();
  }

  Future<void> addBrand(String name) async {

    bool exists = _brands.any((b) => b.name.toLowerCase() == name.toLowerCase());

    if (!exists) {
      final brand = Brand(name: name);
      await _brandBox.add(brand);
      _brands.add(brand);
      notifyListeners();
    }
  }

  Future<void> removeBrand(String name) async {
    try {
      final brandsList = _brandBox.values.toList();
      final index = brandsList.indexWhere(
            (brand) => brand.name.toLowerCase() == name.toLowerCase(),
      );

      if (index != -1) {
        final key = _brandBox.keyAt(index);
        await _brandBox.delete(key);
        loadBrands();
      }
    } catch (e) {
      print('Error deleting brand: $e');
    }
  }

  Future<void> clearAll() async {
    _brands.clear();
    notifyListeners();
  }

}




