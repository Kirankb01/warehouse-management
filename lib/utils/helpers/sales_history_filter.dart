import 'package:warehouse_management/models/sale.dart';



List<Sale> applySaleFilters(List<Sale> allSales, String searchText, String selectedFilter) {
  DateTime now = DateTime.now();

  return allSales.where((sale) {
    final nameMatches =
    sale.customerName.toLowerCase().contains(searchText.toLowerCase());

    bool dateMatches = true;
    if (selectedFilter == 'Today') {
      dateMatches = sale.saleDateTime.year == now.year &&
          sale.saleDateTime.month == now.month &&
          sale.saleDateTime.day == now.day;
    } else if (selectedFilter == 'Last Week') {
      dateMatches = sale.saleDateTime.isAfter(now.subtract(const Duration(days: 7)));
    } else if (selectedFilter == 'Last Month') {
      dateMatches = sale.saleDateTime.isAfter(now.subtract(const Duration(days: 30)));
    }

    return nameMatches && dateMatches;
  }).toList();
}
