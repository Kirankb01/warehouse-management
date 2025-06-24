import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/models/sale.dart';
import 'package:warehouse_management/viewmodel/sales_provider.dart';
import 'package:warehouse_management/viewmodel/summary_view_model.dart';
import 'package:warehouse_management/utils/helpers.dart';

class SellViewModel {
  static Future<void> submitSale({
    required BuildContext context,
    required TextEditingController customerNameController,
    required List<Map<String, TextEditingController>> items,
    required double total,
    required VoidCallback onSuccessResetForm,
  }) async {
    final customerName = customerNameController.text.trim();

    if (customerName.isEmpty) {
      showSnackBar(context, "Please enter customer name");
      return;
    }

    bool hasInvalid = items.any(
      (item) =>
          item['product']!.text.trim().isEmpty ||
          int.tryParse(item['quantity']!.text) == null ||
          double.tryParse(item['price']!.text) == null,
    );

    if (hasInvalid) {
      showSnackBar(context, "Please enter valid product details");
      return;
    }

    final confirm = await showConfirmSaleDialog(context);
    if (!confirm) return;

    final saleItems =
        items
            .map(
              (item) => SaleItem(
                productName: item['product']!.text.trim(),
                quantity: int.parse(item['quantity']!.text),
                price: double.parse(item['price']!.text),
              ),
            )
            .toList();

    final sale = Sale(
      customerName: customerName,
      items: saleItems,
      saleDateTime: DateTime.now(),
      total: total,
    );

    final saleProvider = Provider.of<SalesProvider>(context, listen: false);
    final summaryProvider = Provider.of<SummaryViewModel>(
      context,
      listen: false,
    );

    await saleProvider.addSale(sale);
    if (!context.mounted) return;

    summaryProvider.loadSummaryData();

    showSuccessSnackBar(
      context,
      "Sale submitted successfully! Total: ₹${total.toStringAsFixed(2)}",
    );

    onSuccessResetForm(); // callback to clear form
  }

  static Future<Product?> selectProductFromBottomSheet({
    required BuildContext context,
    required List<Product> allProducts,
  }) async {
    final TextEditingController searchController = TextEditingController();
    List<Product> filteredList = List.from(allProducts);

    final selected = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search product...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setModalState(() {
                        filteredList =
                            allProducts
                                .where(
                                  (product) => product.itemName
                                      .toLowerCase()
                                      .contains(value.toLowerCase()),
                                )
                                .toList();
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text(filteredList[i].itemName),
                          onTap: () => Navigator.pop(context, filteredList[i]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    return selected;
  }
}
