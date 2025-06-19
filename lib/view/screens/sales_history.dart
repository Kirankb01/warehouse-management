import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/view/screens/sale_details_screen.dart';
import 'package:warehouse_management/viewmodel/sales_provider.dart';

class SalesHistoryTab extends StatefulWidget {
  const SalesHistoryTab({super.key});

  @override
  State<SalesHistoryTab> createState() => _SalesHistoryTabState();
}

class _SalesHistoryTabState extends State<SalesHistoryTab> {
  String _searchText = '';
  String _selectedFilter = 'Today';

  final List<String> _filters = ['All', 'Today', 'Last Week', 'Last Month'];

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesProvider>(
      builder: (context, salesProvider, _) {
        final allSales = [...salesProvider.sales]
          ..sort((a, b) => b.saleDateTime.compareTo(a.saleDateTime));
        final filteredSales = applySaleFilters(allSales, _searchText, _selectedFilter);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search customer',
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        filled: true,
                        fillColor: AppColors.pureWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.lightGrey300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Theme(
                          data: Theme.of(context).copyWith(canvasColor: AppColors.pureWhite),
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            isExpanded: true,
                            icon: const Icon(Icons.filter_alt_rounded),
                            items: _filters.map((filter) {
                              return DropdownMenuItem(
                                value: filter,
                                child: Text(filter),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedFilter = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredSales.isEmpty
                  ? const Center(child: Text('No sales history available'))
                  : ListView.builder(
                itemCount: filteredSales.length,
                itemBuilder: (context, index) {
                  final sale = filteredSales[index];
                  final date = sale.saleDateTime;

                  return Card(
                    color: AppColors.card,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        leading: const Icon(Icons.point_of_sale, color: AppColors.successColor),
                        title: Text(
                          sale.customerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Date: ${formatDate(date)} • Time: ${formatTime(date)}'),
                        trailing: Text(
                          '₹${sale.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...sale.items.map((item) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.productName),
                                    Text('Qty: ${item.quantity}'),
                                    Text('₹${item.price.toStringAsFixed(2)}'),
                                  ],
                                )),
                                const SizedBox(height: 10),
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SaleDetailsScreen(sale: sale),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.download),
                                    label: const Text('Download Invoice'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.successColor,
                                      foregroundColor: AppColors.pureWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
