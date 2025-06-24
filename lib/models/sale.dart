import 'package:hive/hive.dart';

part 'sale.g.dart';

@HiveType(typeId: 3)
class Sale extends HiveObject {
  @HiveField(0)
  final String customerName;

  @HiveField(1)
  final List<SaleItem> items;

  @HiveField(2)
  final DateTime saleDateTime;

  @HiveField(3)
  final double total;


  Sale({
    required this.customerName,
    required this.items,
    required this.saleDateTime,
    required this.total,

  });
}

@HiveType(typeId: 4)
class SaleItem {
  @HiveField(0)
  final String productName;

  @HiveField(1)
  final int quantity;

  @HiveField(2)
  final double price;


  SaleItem({
    required this.productName,
    required this.quantity,
    required this.price,
  });
}
