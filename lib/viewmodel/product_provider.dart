import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:warehouse_management/models/sale.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  late Box<Product> _productBox;
  List<Product> _products = [];

  List<Product> get products => _products;

  ProductProvider() {
    _productBox = Hive.box<Product>('productsBox');
    loadProducts();
  }

  Future<void> _reduceStockSilent(String sku, int quantity) async {
    final product = _products.firstWhere((p) => p.sku == sku);
    product.openingStock -= quantity;
    await product.save();
  }

  Future<void> reduceStockForSaleItems(List<SaleItem> saleItems) async {
    for (final saleItem in saleItems) {
      await _reduceStockSilent(saleItem.sku!, saleItem.quantity);
    }
    loadProducts();
  }


  void loadProducts() {
    _products = _productBox.values.toList();
    notifyListeners();
  }

  void addProduct(Product product) async {
    await _productBox.put(product.sku, product);
    loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _productBox.put(product.sku, product);
    loadProducts();
  }

  Future<void> deleteProduct(String sku) async {
    await _productBox.delete(sku);
    print(_productBox.keys);

    loadProducts();

  }

  Future<void> clearAll() async {
    _products.clear();
    notifyListeners();
  }
}
