import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/view/selling_screen/widgets/build_payment_option.dart';

import 'package:warehouse_management/view/selling_screen/widgets/sale_item_form_card.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';

import 'package:warehouse_management/viewmodel/sell_view_model.dart';


class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

enum PaymentMethod { cash, gpay }

class _SellScreenState extends State<SellScreen> {
  final TextEditingController customerNameController = TextEditingController();
  final List<Map<String, TextEditingController>> items = [];
  double total = 0.0;

  PaymentMethod selectedPayment = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    _addNewItem();
  }

  void _addNewItem() {
    final product = TextEditingController();
    final quantity = TextEditingController();
    final price = TextEditingController();
    final sku = TextEditingController();

    quantity.addListener(_calculateTotal);
    price.addListener(_calculateTotal);

    setState(() {
      items.add({
        'product': product,
        'quantity': quantity,
        'price': price,
        'sku': sku,
      });
    });

    _calculateTotal();
  }

  void _removeItem(int index) {
    items[index]['quantity']!.removeListener(_calculateTotal);
    items[index]['price']!.removeListener(_calculateTotal);

    setState(() {
      items.removeAt(index);
    });

    _calculateTotal();
  }

  void _calculateTotal() {
    final newTotal = SellViewModel.calculateTotal(items);
    setState(() {
      total = newTotal;
    });
  }

  Future<void> _selectProduct(int index, List<Product> allProducts) async {
    final selected = await SellViewModel.selectProductFromBottomSheet(
      context: context,
      allProducts: allProducts,
    );

    if (selected != null) {
      setState(() {
        items[index]['product']!.text = selected.itemName;
        items[index]['price']!.text = selected.sellingPrice.toString();
        items[index]['sku']!.text = selected.sku;
      });
    }
  }

  @override
  void dispose() {
    customerNameController.dispose();
    for (var item in items) {
      item['product']!.dispose();
      item['quantity']!.dispose();
      item['price']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final allProducts = productProvider.products;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Sell Products', style: AppTextStyles.appBarText),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                ),
                SizedBox(height: 20),
                Text(
                  'Items:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...List.generate(
                  items.length,
                  (index) => SaleItemFormCard(
                    index: index,
                    items: items,
                    allProducts: allProducts,
                    onRemove: () => _removeItem(index),
                    onSelectProduct: () => _selectProduct(index, allProducts),
                  ),
                ),

                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pureWhite,
                  ),
                  onPressed: _addNewItem,
                  icon: Icon(Icons.add, color: AppColors.summaryContainer),
                  label: Text(
                    'Add Another Item',
                    style: TextStyle(color: AppColors.summaryContainer),
                  ),
                ),
                Divider(height: 30, thickness: 1),
                Text(
                  'Total Price: ₹${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Payment Method',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        elevation: 2,
                        child: Column(
                          children: [
                            buildPaymentOption(
                              context: context,
                              label: 'Cash in Hand',
                              value: PaymentMethod.cash,
                              selected: selectedPayment,
                              onChanged: (value) {
                                setState(() {
                                  selectedPayment = value!;
                                });
                              },
                              icon: Icons.money,
                            ),
                            Divider(height: 0, thickness: 1),
                            buildPaymentOption(
                              context: context,
                              label: 'GPay',
                              value: PaymentMethod.gpay,
                              selected: selectedPayment,
                              onChanged: (value) {
                                setState(() {
                                  selectedPayment = value!;
                                });
                              },
                              icon: Icons.qr_code_2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    SellViewModel.handleSaleSubmission(
                      context: context,
                      customerNameController: customerNameController,
                      items: items,
                      total: total,
                      selectedPayment: selectedPayment,
                      onSuccessResetForm:
                          () => setState(() {
                            total = 0.0;
                          }),
                      onAddNewItem: () => setState(() => _addNewItem()),
                    );
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text('Submit Sale'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successColor,
                    foregroundColor: AppColors.pureWhite,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),

                SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
