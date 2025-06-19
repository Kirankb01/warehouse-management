import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/view/widgets/custom_text_field.dart';
import 'package:warehouse_management/view/widgets/image_picker_box.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';



class EditItem extends StatefulWidget {
  final Product product;

  const EditItem({super.key, required this.product});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController supplierController;
  late TextEditingController nameController;
  late TextEditingController skuController;
  late TextEditingController stockController;
  late TextEditingController reorderController;
  late TextEditingController sellingController;
  late TextEditingController costController;

  String? _imagePath;
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
    supplierController = TextEditingController(text: widget.product.supplierName);
    nameController = TextEditingController(text: widget.product.itemName);
    skuController = TextEditingController(text: widget.product.sku);
    stockController = TextEditingController(text: widget.product.openingStock.toString());
    reorderController = TextEditingController(text: widget.product.reorderPoint.toString());
    sellingController = TextEditingController(text: widget.product.sellingPrice.toString());
    costController = TextEditingController(text: widget.product.costPrice.toString());
    _imagePath = widget.product.imagePath;
    selectedBrand = widget.product.brand;
  }

  @override
  void dispose() {
    supplierController.dispose();
    nameController.dispose();
    skuController.dispose();
    stockController.dispose();
    reorderController.dispose();
    sellingController.dispose();
    costController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Edit Item',
          style: AppTextStyles.appBarText.copyWith(
            fontSize: size.width < 600 ? 20 : 26,
          ),
        ),
        backgroundColor: AppColors.background,
        actions: [
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                final updatedProduct = Product(
                  supplierName: supplierController.text,
                  itemName: nameController.text,
                  sku: skuController.text,
                  brand: selectedBrand ?? '',
                  openingStock: int.tryParse(stockController.text) ?? 0,
                  reorderPoint: int.tryParse(reorderController.text) ?? 0,
                  sellingPrice: double.tryParse(sellingController.text) ?? 0.0,
                  costPrice: double.tryParse(costController.text) ?? 0.0,
                  imagePath: _imagePath,
                );

                Provider.of<ProductProvider>(context, listen: false)
                    .updateProduct(updatedProduct);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.summaryContainer,
                    content: Text('Item updated successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: size.width * 0.05),
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: size.width < 600 ? 16 : 22,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: ImagePickerBox(
                    imagePath: _imagePath,
                    onTap: _pickImage,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.inventory_2_rounded),
                            SizedBox(width: 8),
                            Text('Product Details', style: AppTextStyles.sectionHeading),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildCustomTextField('Supplier Name', supplierController, isRequired: true),
                        buildCustomTextField('Item Name', nameController, isRequired: true),
                        buildCustomTextField('SKU', skuController, isRequired: true),

                        Padding(
                          padding: const EdgeInsets.only(right: 246),
                          child: Text('Brand',style: TextStyle(fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        /// ✅ Brand Dropdown
                        Consumer<BrandProvider>(
                          builder: (context, brandProvider, _) {
                            final brandList = brandProvider.brands;
                            return DropdownButtonFormField<String>(
                              value: selectedBrand,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.inputBackground,
                                hintText: 'Select Brand',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: brandList.map((brand) {
                                return DropdownMenuItem<String>(
                                  value: brand.name,
                                  child: Text(brand.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedBrand = value;
                                });
                              },
                              validator: (value) =>
                              value == null || value.isEmpty ? 'Please select a brand' : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.store_rounded),
                            SizedBox(width: 8),
                            Text('Stock Information', style: AppTextStyles.sectionHeading),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: buildCustomTextField('Opening Stock', stockController,
                                  type: TextInputType.number, isRequired: true),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: buildCustomTextField('Reorder Point', reorderController,
                                  type: TextInputType.number, isRequired: true),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.price_change_rounded),
                            SizedBox(width: 8),
                            Text('Pricing Information', style: AppTextStyles.sectionHeading),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: buildCustomTextField('Selling Price', sellingController,
                                  type: TextInputType.number, isRequired: true),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: buildCustomTextField('Cost Price', costController,
                                  type: TextInputType.number, isRequired: true),
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
