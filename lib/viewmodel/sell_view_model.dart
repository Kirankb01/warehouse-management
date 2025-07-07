import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/models/sale.dart';
import 'package:warehouse_management/view/selling_screen/widgets/qr_payment_screen.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';
import 'package:warehouse_management/viewmodel/sales_provider.dart';
import 'package:warehouse_management/viewmodel/summary_view_model.dart';
import 'package:warehouse_management/utils/helpers.dart';
import '../view/selling_screen/screens/selling_screen.dart';


class SellViewModel {

  static Future<void> submitSale({
    required BuildContext context,
    required TextEditingController customerNameController,
    required List<Map<String, TextEditingController>> items,
    required double total,
    required PaymentMethod selectedPayment, // no need to use this anymore inside
    required VoidCallback onSuccessResetForm,
  }) async {
    final customerName = customerNameController.text.trim();

    final saleItems = items.map(
          (item) => SaleItem(
        productName: item['product']!.text.trim(),
        quantity: int.parse(item['quantity']!.text),
        price: double.parse(item['price']!.text),
        sku: item['sku']!.text.trim(),
      ),
    ).toList();

    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    for (final saleItem in saleItems) {
      final product = productProvider.products.firstWhere(
            (p) => p.sku == saleItem.sku,
        orElse: () => throw Exception('Product ${saleItem.sku} not found'),
      );

      if (saleItem.quantity > product.openingStock) {
        showSnackBar(
          context,
          "Insufficient stock for ${product.itemName}. Available: ${product.openingStock}",
        );
        return;
      }
    }

    final sale = Sale(
      customerName: customerName,
      items: saleItems,
      saleDateTime: DateTime.now(),
      total: total,
    );

    final saleProvider = Provider.of<SalesProvider>(context, listen: false);
    final summaryProvider = Provider.of<SummaryViewModel>(context, listen: false);

    await saleProvider.addSale(sale);
    await productProvider.reduceStockForSaleItems(saleItems);

    if (!context.mounted) return;

    summaryProvider.loadSummaryData();

    showSuccessSnackBar(
      context,
      "Sale submitted successfully! Total: ₹${total.toStringAsFixed(2)}",
    );

    onSuccessResetForm();
  }


  // selecting product for selling

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
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
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
                              filteredList = allProducts
                                  .where((product) => product.itemName
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
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
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    return selected;
  }




  // Validation Function

  static bool validateSaleInputs({
    required BuildContext context,
    required TextEditingController customerNameController,
    required List<Map<String, TextEditingController>> items,
  }) {
    final customerName = customerNameController.text.trim();
    if (customerName.isEmpty) {
      showSnackBar(context, "Please enter customer name");
      return false;
    }

    bool hasInvalid = items.any(
          (item) =>
      item['product']!.text.trim().isEmpty ||
          int.tryParse(item['quantity']!.text) == null ||
          double.tryParse(item['price']!.text) == null,
    );
    if (hasInvalid) {
      showSnackBar(context, "Please enter valid product details");
      return false;
    }

    return true;
  }


  // Reset Form Helper

  static void resetSaleForm({
    required TextEditingController customerNameController,
    required List<Map<String, TextEditingController>> items,
    required VoidCallback onReset,
  }) {
    customerNameController.clear();
    items.clear();
    onReset();
  }


  // Handle Full Submit Flow

  static Future<void> handleSaleSubmission({
    required BuildContext context,
    required TextEditingController customerNameController,
    required List<Map<String, TextEditingController>> items,
    required double total,
    required PaymentMethod selectedPayment,
    required VoidCallback onSuccessResetForm,
    required VoidCallback onAddNewItem,
  }) async {
    if (!validateSaleInputs(
      context: context,
      customerNameController: customerNameController,
      items: items,
    )) {
      return;
    }

    final confirmed = await showConfirmSaleDialog(
      context,
      selectedPayment: selectedPayment,
    );
    if (!confirmed) return;

    if (selectedPayment == PaymentMethod.cash) {
      await submitSale(
        context: context,
        customerNameController: customerNameController,
        items: items,
        total: total,
        selectedPayment: selectedPayment,
        onSuccessResetForm: () {
          resetSaleForm(
            customerNameController: customerNameController,
            items: items,
            onReset: onSuccessResetForm,
          );
          onAddNewItem(); // call setState to add a fresh item
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QrPaymentScreen(
            amount: total,
            onPaid: () {
              submitSale(
                context: context,
                customerNameController: customerNameController,
                items: items,
                total: total,
                selectedPayment: selectedPayment,
                onSuccessResetForm: () {
                  resetSaleForm(
                    customerNameController: customerNameController,
                    items: items,
                    onReset: onSuccessResetForm,
                  );
                  onAddNewItem();
                },
              );
            },
          ),
        ),
      );
    }
  }

  // calculation logic in selling products

  static double calculateTotal(List<Map<String, TextEditingController>> items) {
    double total = 0.0;
    for (var item in items) {
      final qty = int.tryParse(item['quantity']!.text) ?? 0;
      final price = double.tryParse(item['price']!.text) ?? 0.0;
      total += qty * price;
    }
    return total;
  }


}
