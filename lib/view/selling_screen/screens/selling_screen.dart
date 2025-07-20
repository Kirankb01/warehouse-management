import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/models/sale.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
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
  final TextEditingController customerMobileController =
      TextEditingController();
  final TextEditingController customerEmailController = TextEditingController();

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
    setState(() => items.removeAt(index));
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
      FocusScope.of(context).unfocus();
      setState(() {
        items[index]['product']!.text = selected.itemName;
        items[index]['price']!.text = selected.sellingPrice.toString();
        items[index]['sku']!.text = selected.sku;
      });
    }
  }

  Future<List<Map<String, String>>> getUniqueCustomers() async {
    final box = await Hive.openBox<Sale>('salesBox');
    final customers = <String, Map<String, String>>{};

    for (var sale in box.values) {
      final name = sale.customerName.trim();
      if (!customers.containsKey(name)) {
        customers[name] = {
          'name': name,
          'phone': sale.customerMobile ?? '',
          'email': sale.customerEmail ?? '',
        };
      }
    }

    return customers.values.toList();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerMobileController.dispose();
    customerEmailController.dispose();
    for (var item in items) {
      item['product']!.dispose();
      item['quantity']!.dispose();
      item['price']!.dispose();
      item['sku']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final background = AppThemeHelper.scaffoldBackground(context);
    final cardColor = AppThemeHelper.cardColor(context);
    final textColor = AppThemeHelper.textColor(context);

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final allProducts = productProvider.products;

        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: background,
            title: Text('Sell Products', style: AppTextStyles.appBarText),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(cardColor: cardColor),
                  child: TypeAheadField<Map<String, String>>(
                    controller: customerNameController,
                    hideOnEmpty: false,
                    debounceDuration: const Duration(milliseconds: 300),
                    suggestionsCallback: (String pattern) async {
                      final customers = await getUniqueCustomers();
                      return customers
                          .where(
                            (c) => c['name']!.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                          )
                          .toList();
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion['name'] ?? ''),
                        subtitle: Text(suggestion['phone'] ?? ''),
                      );
                    },
                    onSelected: (suggestion) {
                      customerNameController.text = suggestion['name'] ?? '';
                      customerMobileController.text = suggestion['phone'] ?? '';
                      customerEmailController.text = suggestion['email'] ?? '';
                    },
                    builder: (context, _, focusNode) {
                      return TextFormField(
                        controller: customerNameController,
                        focusNode: focusNode,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Customer Name',
                          filled: true,
                          fillColor: cardColor,
                          hintText: 'Enter Customer Name',
                          hintStyle: TextStyle(color: textColor.withAlpha(120)),
                          labelStyle: TextStyle(
                            color: textColor.withAlpha(180),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    emptyBuilder:
                        (context) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("No matching customers found"),
                        ),
                  ),
                ),

                const SizedBox(height: 10),
                TextField(
                  controller: customerMobileController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'Enter mobile number',
                    hintStyle: TextStyle(color: textColor.withAlpha(150)),
                    labelStyle: TextStyle(color: textColor.withAlpha(180)),
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: customerEmailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Email ID',
                    hintText: 'Enter email address',
                    hintStyle: TextStyle(color: textColor.withAlpha(150)),
                    labelStyle: TextStyle(color: textColor.withAlpha(180)),
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Items:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cardColor,
                    foregroundColor: AppColors.summaryContainer,
                  ),
                  onPressed: _addNewItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Another Item'),
                ),
                const Divider(height: 30, thickness: 1),
                Text(
                  'Total Price: ₹${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: cardColor,
                  elevation: 2,
                  child: Column(
                    children: [
                      buildPaymentOption(
                        context: context,
                        label: 'Cash in Hand',
                        value: PaymentMethod.cash,
                        selected: selectedPayment,
                        onChanged:
                            (value) => setState(() => selectedPayment = value!),
                        icon: Icons.money,
                      ),
                      const Divider(height: 0, thickness: 1),
                      buildPaymentOption(
                        context: context,
                        label: 'GPay',
                        value: PaymentMethod.gpay,
                        selected: selectedPayment,
                        onChanged:
                            (value) => setState(() => selectedPayment = value!),
                        icon: Icons.qr_code_2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    SellViewModel.handleSaleSubmission(
                      context: context,
                      customerNameController: customerNameController,
                      customerMobileController: customerMobileController,
                      customerEmailController: customerEmailController,
                      items: items,
                      total: total,
                      selectedPayment: selectedPayment,
                      onSuccessResetForm: () => setState(() => total = 0.0),
                      onAddNewItem: () => setState(() => _addNewItem()),
                    );
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Submit Sale'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successColor,
                    foregroundColor: AppColors.pureWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size.fromHeight(50),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
