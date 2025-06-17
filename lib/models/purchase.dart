import 'package:hive/hive.dart';

part 'purchase.g.dart';

@HiveType(typeId: 5)
class Purchase extends HiveObject {
  @HiveField(0)
  final String supplierName;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final DateTime dateTime;

  Purchase({
    required this.supplierName,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.dateTime,
  });

  double get total => quantity * price;
}
