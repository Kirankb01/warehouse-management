import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/models/purchase.dart';
import 'package:warehouse_management/view/widgets/custom_text_field.dart';
import 'package:warehouse_management/view/widgets/image_picker_box.dart';
import 'package:warehouse_management/viewmodel/add_item_view_model.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';
import 'package:warehouse_management/viewmodel/summary_view_model.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();

  final supplierController = TextEditingController();
  final nameController = TextEditingController();
  final skuController = TextEditingController();
  final brandController = TextEditingController();
  final stockController = TextEditingController();
  final reorderController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final costPriceController = TextEditingController();
  String? imagePath;

  @override
  void dispose() {
    supplierController.dispose();
    nameController.dispose();
    skuController.dispose();
    brandController.dispose();
    stockController.dispose();
    reorderController.dispose();
    sellingPriceController.dispose();
    costPriceController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        supplierName: supplierController.text.trim(),
        itemName: nameController.text.trim(),
        sku: skuController.text.trim(),
        brand: brandController.text.trim(),
        openingStock: int.tryParse(stockController.text.trim()) ?? 0,
        reorderPoint: int.tryParse(reorderController.text.trim()) ?? 0,
        sellingPrice:
        double.tryParse(sellingPriceController.text.trim()) ?? 0.0,
        costPrice: double.tryParse(costPriceController.text.trim()) ?? 0.0,
        imagePath: imagePath,
      );

      final newPurchase = Purchase(
        supplierName: supplierController.text.trim(),
        productName: nameController.text.trim(),
        quantity: int.tryParse(stockController.text.trim()) ?? 0,
        price: double.tryParse(costPriceController.text.trim()) ?? 0.0,
        dateTime: DateTime.now(),
      );

      final saveSuccess = await AddItemViewModel().saveItemToHive(newProduct, newPurchase);

      if (!mounted) return;

      if (saveSuccess) {
        Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
        Provider.of<SummaryViewModel>(context, listen: false).loadSummaryData();

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item saved and purchase recorded!'),
            backgroundColor: AppColors.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving item'),
            backgroundColor: AppColors.alertColor,
          ),
        );
      }
    }
  }



  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => imagePath = pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final brandProvider = Provider.of<BrandProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        title: Text('Add Item', style: AppTextStyles.appBarText),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.04),
            child: TextButton(
              onPressed: _saveItem,
              child: Text('Save', style: AppTextStyles.actionText),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ImagePickerBox(imagePath: imagePath, onTap: pickImage),
                ),

                const SizedBox(height: 24),

                const SizedBox(height: 8),
                Card(
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.inventory_2_rounded),
                            Text(
                              ' Product Details',
                              style:
                                  AppTextStyles
                                      .sectionHeading, // Use your custom style or define one
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        buildCustomTextField(
                          'Supplier Name',
                          supplierController,
                          isRequired: true,
                        ),
                        buildCustomTextField(
                          'Item Name',
                          nameController,
                          isRequired: true,
                        ),
                        buildCustomTextField(
                          'SKU',
                          skuController,
                          isRequired: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 246),
                          child: Text(
                            'Brand',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor:
                                  AppColors
                                      .content, // 👈 Dropdown background color
                            ),
                            child: DropdownButtonFormField<String>(
                              value:
                                  brandController.text.isNotEmpty
                                      ? brandController.text
                                      : null,
                              onChanged: (value) {
                                setState(() => brandController.text = value!);
                              },
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Please select a brand'
                                          : null,
                              decoration: buildInputDecoration('Brand'),
                              icon: const Icon(Icons.arrow_drop_down),
                              items:
                                  brandProvider.brands
                                      .map(
                                        (brand) => DropdownMenuItem(
                                          value: brand.name,
                                          child: Text(brand.name),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Card(
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.store_rounded),
                            Text(
                              ' Stock Information',
                              style:
                                  AppTextStyles
                                      .sectionHeading, // Use your custom style or define one
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: buildCustomTextField(
                                'Opening Stock',
                                stockController,
                                type: TextInputType.number,
                                isRequired: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: buildCustomTextField(
                                'Reorder Point',
                                reorderController,
                                type: TextInputType.number,
                                isRequired: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Card(
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.price_change_rounded),
                            Text(
                              ' Pricing Information',
                              style:
                                  AppTextStyles
                                      .sectionHeading, // Use your custom style or define one
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: buildCustomTextField(
                                'Selling Price',
                                sellingPriceController,
                                type: TextInputType.number,
                                isRequired: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: buildCustomTextField(
                                'Cost Price',
                                costPriceController,
                                type: TextInputType.number,
                                isRequired: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
