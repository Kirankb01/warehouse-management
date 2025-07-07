import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/purchase.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/view/sales_purchase_history_screen/widgets/purchase_details_screen.dart';


class PurchaseHistoryTab extends StatefulWidget {
  const PurchaseHistoryTab({super.key});

  @override
  State<PurchaseHistoryTab> createState() => _PurchaseHistoryTabState();
}

class _PurchaseHistoryTabState extends State<PurchaseHistoryTab> {
  String _searchText = '';
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Today', 'Last Week', 'Last Month'];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Purchase>>(
      valueListenable: Hive.box<Purchase>('purchases').listenable(),
      builder: (context, box, _) {
        final allPurchases = box.values.toList().cast<Purchase>();
        allPurchases.sort(
          (a, b) => b.dateTime.compareTo(a.dateTime),
        );

        final filteredPurchases =
            allPurchases.where((purchase) {
              final matchesSearch =
                  purchase.productName.toLowerCase().contains(
                    _searchText.toLowerCase(),
                  ) ||
                  purchase.supplierName.toLowerCase().contains(
                    _searchText.toLowerCase(),
                  );

              final matchesDate = matchesDateFilter(
                purchase.dateTime,
                _selectedFilter,
              );
              return matchesSearch && matchesDate;
            }).toList();

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
                        hintText: 'Search supplier or product',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        filled: true,
                        fillColor: AppColors.pureWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) => setState(() => _searchText = value),
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
                        border: Border.all(color: AppColors.lightBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(canvasColor: AppColors.pureWhite),
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            isExpanded: true,
                            icon: const Icon(Icons.filter_alt_rounded),
                            items:
                                _filters.map((filter) {
                                  return DropdownMenuItem(
                                    value: filter,
                                    child: Text(filter),
                                  );
                                }).toList(),
                            onChanged:
                                (value) =>
                                    setState(() => _selectedFilter = value!),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child:
                  filteredPurchases.isEmpty
                      ? const Center(child: Text('No purchases found'))
                      : ListView.builder(
                        itemCount: filteredPurchases.length,
                        itemBuilder: (context, index) {
                          final purchase = filteredPurchases[index];
                          return Card(
                            color: AppColors.card,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Theme(
                              data: Theme.of(
                                context,
                              ).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                leading: const Icon(
                                  Icons.shopping_cart,
                                  color: AppColors.primary,
                                ),
                                title: Text(
                                  purchase.supplierName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  formatDateTime(purchase.dateTime),
                                ),
                                trailing: Text(
                                  '₹${purchase.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(purchase.productName),
                                            Text('Qty: ${purchase.quantity}'),
                                            Text(
                                              '₹${purchase.price.toStringAsFixed(2)}',
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Center(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          PurchaseDetailsScreen(
                                                            purchase: purchase,
                                                          ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              foregroundColor: AppColors.pureWhite,
                                            ),
                                            icon: const Icon(Icons.download),
                                            label: const Text(
                                              'Download Invoice',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
