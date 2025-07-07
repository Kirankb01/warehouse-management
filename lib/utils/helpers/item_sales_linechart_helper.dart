import 'package:hive/hive.dart';

import '../../models/sale.dart';

class ItemSalesHelper {
  static Map<String, double> computeItemSales(
      String selectedPieFilter, {
        required String hiveBoxName,
        required String itemSku,
      }) {
    final salesBox = Hive.box<Sale>(hiveBoxName);

    print('Sales in box: ${salesBox.values.length}');
    print('Filtering for SKU: $itemSku');

// Debug all sales and items
    for (final sale in salesBox.values) {
      print('Sale ID: ${sale.key}, Date: ${sale.saleDateTime}');
      for (final saleItem in sale.items) {
        print('  - Item SKU: ${saleItem.sku}, Quantity: ${saleItem.quantity}, Price: ${saleItem.price}');
      }
    }


    final sales = salesBox.values.where(
          (sale) => sale.items.any((item) => item.sku == itemSku),
    );



    final now = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;

    switch (selectedPieFilter) {
      case 'This Week':
        startDate = DateTime(
          now.year,
          now.month,
          now.day - (now.weekday - 1),
          0,
          0,
          0,
        );
        endDate = startDate.add(
          const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        break;
      case 'Last Week':
        final lastMonday = now.subtract(Duration(days: now.weekday + 6));
        final lastSunday = lastMonday.add(
          const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        startDate = lastMonday;
        endDate = lastSunday;
        break;
      case 'This Month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(
          now.year,
          now.month + 1,
          0,
          23,
          59,
          59,
        );
        break;
      case 'Last 3 Month':
        startDate = DateTime(
          now.year,
          now.month - 2,
          1,
        );
        endDate = DateTime(
          now.year,
          now.month,
          DateTime(now.year, now.month + 1, 0).day,
          23,
          59,
          59,
        );
        break;
      default:
        startDate = null;
        endDate = null;
    }

    final filteredSales = sales.where((sale) {
      final isAfterStart = startDate == null || sale.saleDateTime.isAfter(startDate) || sale.saleDateTime.isAtSameMomentAs(startDate);
      final isBeforeEnd = endDate == null || sale.saleDateTime.isBefore(endDate) || sale.saleDateTime.isAtSameMomentAs(endDate);
      return isAfterStart && isBeforeEnd;
    });

    Map<String, double> tempMonthly = {};

    for (final sale in filteredSales) {
      final y = sale.saleDateTime.year;
      final m = sale.saleDateTime.month;
      final d = sale.saleDateTime.day;

      // Adjust key format depending on filter
      final key = selectedPieFilter == 'Last 3 Month' ? '$y-$m' : '$y-$m-$d';

      // Only sum this product's price * quantity
      final matchingItems = sale.items.where((item) => item.sku == itemSku);
      final matchingTotal = matchingItems.fold(
        0.0,
            (sum, item) => sum + (item.price * item.quantity),
      );

      tempMonthly[key] = (tempMonthly[key] ?? 0) + matchingTotal;
    }

    return tempMonthly;
  }
}
