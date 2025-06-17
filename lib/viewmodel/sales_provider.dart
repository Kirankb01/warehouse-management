import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/sale.dart';

class SalesProvider extends ChangeNotifier {
  late Box<Sale> _salesBox;
  List<Sale> _sales = [];

  List<Sale> get sales => _sales.reversed.toList(); // latest first

  SalesProvider() {
    _salesBox = Hive.box<Sale>('salesBox');
    loadSales();
  }

  void loadSales() {
    _sales = _salesBox.values.toList();
    notifyListeners();
  }

  Future<void> addSale(Sale sale) async {
    await _salesBox.add(sale);
    loadSales();
  }

  Future<void> deleteSale(int index) async {
    await _salesBox.deleteAt(index);
    loadSales();
  }

  Future<void> clearAllSales() async {
    await _salesBox.clear();
    loadSales();
  }
}
