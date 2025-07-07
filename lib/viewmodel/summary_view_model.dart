import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/sale.dart';
import '../models/purchase.dart';

class SummaryViewModel extends ChangeNotifier {
  double? screenWidth;
  double? screenHeight;

  SummaryViewModel() {
    Future.microtask(() => loadSummaryData());
  }

  void initScreenSize(double width, double height) {
    screenWidth ??= width;
    screenHeight ??= height;
  }

  int soldQty = 0;
  double earnings = 0;
  int purchasedQty = 0;
  double spendings = 0;
  String selectedFilter = 'Today';

  void setFilter(String newFilter) {
    selectedFilter = newFilter;
    loadSummaryData();
  }


  void loadSummaryData() {
    try {
      final saleBox = Hive.box<Sale>('salesBox');
      final purchaseBox = Hive.box<Purchase>('purchases');

      final now = DateTime.now();

      final sales = saleBox.values.where((sale) {
        return _isInFilter(sale.saleDateTime, now);
      });

      final purchases = purchaseBox.values.where((purchase) {
        return _isInFilter(purchase.dateTime, now);
      });

      soldQty = sales.fold(0, (sum, sale) {
        return sum + sale.items.fold(0, (itemSum, item) => itemSum + item.quantity);
      });

      earnings = sales.fold(0.0, (sum, sale) => sum + sale.total);
      purchasedQty = purchases.fold(0, (sum, purchase) => sum + purchase.quantity);
      spendings = purchases.fold(0.0, (sum, purchase) => sum + purchase.total);

      notifyListeners();
    } catch (e, stack) {
      debugPrint(' Error loading summary data: $e\n$stack');
    }
  }

  bool _isInFilter(DateTime date, DateTime now) {
    switch (selectedFilter) {
      case 'Today':
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;

      case 'This Week':
        final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
        return date.isAfter(firstDayOfWeek.subtract(const Duration(days: 1))) &&
            date.isBefore(lastDayOfWeek.add(const Duration(days: 1)));

      case 'This Month':
        return date.year == now.year && date.month == now.month;

      default:
        return true;
    }
  }
}
