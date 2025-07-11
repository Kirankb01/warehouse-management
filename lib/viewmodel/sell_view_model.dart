import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/models/sale.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
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
    required TextEditingController customerMobileController,
    required TextEditingController customerEmailController,
    required List<Map<String, TextEditingController>> items,
    required double total,
    required PaymentMethod selectedPayment,
    required VoidCallback onSuccessResetForm,
  }) async {
    final customerName = customerNameController.text.trim();
    final customerMobile = customerMobileController.text.trim();
    final customerEmail = customerEmailController.text.trim();

    final saleItems = items.map(
          (item) => SaleItem(
        productName: item['product']!.text.trim(),
        quantity: int.tryParse(item['quantity']!.text) ?? 0,
        price: double.tryParse(item['price']!.text) ?? 0.0,
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
      customerMobile: customerMobile.isNotEmpty ? customerMobile : null,
      customerEmail: customerEmail.isNotEmpty ? customerEmail : null,
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

  static bool validateSaleInputs({
    required BuildContext context,
    required TextEditingController customerNameController,
    required List<Map<String, TextEditingController>> items,
    TextEditingController? customerMobileController,
    TextEditingController? customerEmailController,
  }) {
    final name = customerNameController.text.trim();

    if (name.isEmpty) {
      showSnackBar(context, "Please enter customer name");
      return false;
    }

    final mobile = customerMobileController?.text.trim();
    if (mobile != null && mobile.isNotEmpty) {
      final mobileRegex = RegExp(r'^\d{10}$');
      if (!mobileRegex.hasMatch(mobile)) {
        showSnackBar(context, "Enter a valid 10-digit mobile number");
        return false;
      }
    }

    final email = customerEmailController?.text.trim();
    if (email != null && email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        showSnackBar(context, "Enter a valid email address");
        return false;
      }
    }

    final hasInvalid = items.any((item) {
      return item['product']!.text.trim().isEmpty ||
          int.tryParse(item['quantity']!.text) == null ||
          double.tryParse(item['price']!.text) == null;
    });

    if (hasInvalid) {
      showSnackBar(context, "Please enter valid product details");
      return false;
    }

    return true;
  }




  static void resetSaleForm({
    required TextEditingController customerNameController,
    required TextEditingController customerMobileController,
    required TextEditingController customerEmailController,
    required List<Map<String, TextEditingController>> items,
    required VoidCallback onReset,
  }) {
    customerNameController.clear();
    customerMobileController.clear();
    customerEmailController.clear();
    items.clear();
    onReset();
  }

  static Future<void> handleSaleSubmission({
    required BuildContext context,
    required TextEditingController customerNameController,
    required TextEditingController customerMobileController,
    required TextEditingController customerEmailController,
    required List<Map<String, TextEditingController>> items,
    required double total,
    required PaymentMethod selectedPayment,
    required VoidCallback onSuccessResetForm,
    required VoidCallback onAddNewItem,
  }) async {
    if (!validateSaleInputs(
      context: context,
      customerNameController: customerNameController,
      customerMobileController: customerMobileController,
      customerEmailController: customerEmailController,
      items: items,
    )) return;

    final confirmed = await showConfirmSaleDialog(
      context,
      selectedPayment: selectedPayment,
    );

    if (!confirmed) return;

    submit() => submitSale(
      context: context,
      customerNameController: customerNameController,
      customerMobileController: customerMobileController,
      customerEmailController: customerEmailController,
      items: items,
      total: total,
      selectedPayment: selectedPayment,
      onSuccessResetForm: () {
        resetSaleForm(
          customerNameController: customerNameController,
          customerMobileController: customerMobileController,
          customerEmailController: customerEmailController,
          items: items,
          onReset: onSuccessResetForm,
        );
        onAddNewItem();
      },
    );

    if (selectedPayment == PaymentMethod.cash) {
      await submit();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QrPaymentScreen(
            amount: total,
            onPaid: () => submit(),
          ),
        ),
      );
    }
  }

  static Future<Product?> selectProductFromBottomSheet({
    required BuildContext context,
    required List<Product> allProducts,
  }) async {
    final searchController = TextEditingController();
    List<Product> filteredList = List.from(allProducts);

    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final backgroundColor = AppThemeHelper.dialogBackground(context);

    return await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Search product...',
                          hintStyle: TextStyle(color: textColor.withAlpha((0.6 * 255).toInt())),
                          prefixIcon: Icon(Icons.search, color: textColor.withAlpha((0.6 * 255).toInt())),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            filteredList = allProducts
                                .where((p) => p.itemName
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
                          itemBuilder: (context, i) => ListTile(
                            title: Text(
                              filteredList[i].itemName,
                              style: TextStyle(color: textColor),
                            ),
                            onTap: () => Navigator.pop(context, filteredList[i]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }


  static double calculateTotal(
      List<Map<String, TextEditingController>> items) {
    return items.fold(0.0, (sum, item) {
      final qty = int.tryParse(item['quantity']!.text) ?? 0;
      final price = double.tryParse(item['price']!.text) ?? 0.0;
      return sum + (qty * price);
    });
  }
}
