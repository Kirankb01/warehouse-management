import 'package:hive/hive.dart';
import 'package:warehouse_management/models/sale.dart';

class SalesHelper {
  static Map<String, double> computeMonthlySales(
      String selectedPieFilter, {
        required String hiveBoxName,
      }) {
    final salesBox = Hive.box<Sale>(hiveBoxName);
    final sales = salesBox.values;

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
        startDate = DateTime(now.year, now.month, 1); // first of this month
        endDate = DateTime(
          now.year,
          now.month + 1,
          0,
          23,
          59,
          59,
        ); // last of this month
        break;

      case 'Last 3 Month':
        startDate = DateTime(now.year, now.month - 2, 1); // first of 3 months ago
        endDate = DateTime(
          now.year,
          now.month,
          DateTime(now.year, now.month + 1, 0).day,
          23,
          59,
          59,
        ); // last of this month
        break;

      default:
        startDate = null;
        endDate = null;
    }

    final filteredSales = sales.where((sale) {
      final isAfterStart = startDate == null ||
          sale.saleDateTime.isAfter(startDate) ||
          sale.saleDateTime.isAtSameMomentAs(startDate);
      final isBeforeEnd = endDate == null ||
          sale.saleDateTime.isBefore(endDate) ||
          sale.saleDateTime.isAtSameMomentAs(endDate);
      return isAfterStart && isBeforeEnd;
    });

    Map<String, double> tempMonthly = {};
    for (final sale in filteredSales) {
      final y = sale.saleDateTime.year;
      final m = sale.saleDateTime.month;
      final d = sale.saleDateTime.day;

      String key;
      if (selectedPieFilter == 'Last 3 Month') {
        key = '$y-$m';
      } else {
        key = '$y-$m-$d';
      }

      tempMonthly[key] = (tempMonthly[key] ?? 0) + sale.total;
    }

    return tempMonthly;
  }
}
