import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String supplierName;

  @HiveField(1)
  String itemName;

  @HiveField(2)
  String sku;

  @HiveField(3)
  String brand;

  @HiveField(4)
  int openingStock;

  @HiveField(5)
  int reorderPoint;

  @HiveField(6)
  double sellingPrice;

  @HiveField(7)
  double costPrice;

  @HiveField(8)
  String? imagePath;

  @HiveField(9)
  String? description;

  Product({
    required this.supplierName,
    required this.itemName,
    required this.sku,
    required this.brand,
    required this.openingStock,
    required this.reorderPoint,
    required this.sellingPrice,
    required this.costPrice,
    this.imagePath,
    required this.description
  });


}
