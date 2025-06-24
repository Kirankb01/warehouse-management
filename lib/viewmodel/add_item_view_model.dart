import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/models/purchase.dart';


class AddItemViewModel {
  Future<bool> saveItemToHive(Product newProduct, Purchase newPurchase) async {
    try {
      final purchaseBox = Hive.box<Purchase>('purchases');
      await purchaseBox.add(newPurchase);
      return true;
    } catch (error) {
      debugPrint("Error in saveItemToHive: $error");
      return false;
    }
  }
}

