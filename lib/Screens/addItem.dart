import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/providers/product_provider.dart';
import 'package:warehouse_management/widgets/custom_text_field.dart';


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

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        supplierName: supplierController.text,
        itemName: nameController.text,
        sku: skuController.text,
        brand: brandController.text,
        openingStock: int.tryParse(stockController.text) ?? 0,
        reorderPoint: int.tryParse(reorderController.text) ?? 0,
        sellingPrice: double.tryParse(sellingPriceController.text) ?? 0.0,
        costPrice: double.tryParse(costPriceController.text) ?? 0.0,
        imagePath:
            imagePath, // If you're using imagePath, set it earlier in your widget
      );

      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).addProduct(newProduct);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Add Item', style: AppTextStyles.appBarText),
        backgroundColor: AppColors.background,
        actions: [
          GestureDetector(
            onTap: _saveItem,
            child: Padding(
              padding: EdgeInsets.only(right: size.width * 0.04),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: size.height * 0.16,
                      width: size.width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white,
                          width: size.width * 0.015,
                        ),
                        color: const Color(0xFFE3EAF6),
                      ),
                      child:
                          imagePath == null
                              ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_rounded, size: 35),
                                  Text('Add Image'),
                                ],
                              )
                              : Image.file(File(imagePath!), fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
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
                        buildCustomTextField(
                          'Brand',
                          brandController,
                          isRequired: true,
                        ),
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
                        const SizedBox(height: 15),
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
