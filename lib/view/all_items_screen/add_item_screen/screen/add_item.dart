import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/models/purchase.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/all_items_screen/add_item_screen/widgets/overview_section.dart';
import 'package:warehouse_management/view/all_items_screen/add_item_screen/widgets/pricing_information_section.dart';
import 'package:warehouse_management/view/all_items_screen/add_item_screen/widgets/product_details_section.dart';
import 'package:warehouse_management/view/all_items_screen/add_item_screen/widgets/stock_information_section.dart';
import 'package:warehouse_management/view/shared_widgets/image_picker_box.dart';
import 'package:warehouse_management/viewmodel/add_item_view_model.dart';

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
  final descriptionController = TextEditingController();

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
    descriptionController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        supplierName: supplierController.text.trim(),
        itemName: nameController.text.trim(),
        sku: skuController.text.trim(),
        brand: brandController.text.trim(),
        openingStock: int.tryParse(stockController.text.trim()) ?? 0,
        reorderPoint: int.tryParse(reorderController.text.trim()) ?? 0,
        sellingPrice: double.tryParse(sellingPriceController.text.trim()) ?? 0.0,
        costPrice: double.tryParse(costPriceController.text.trim()) ?? 0.0,
        imagePath: imagePath,
        description: descriptionController.text.trim(),
      );

      final newPurchase = Purchase(
        supplierName: supplierController.text.trim(),
        productName: nameController.text.trim(),
        quantity: int.tryParse(stockController.text.trim()) ?? 0,
        price: double.tryParse(costPriceController.text.trim()) ?? 0.0,
        dateTime: DateTime.now(),
      );

      AddItemViewModel.saveItem(
        context: context,
        product: newProduct,
        purchase: newPurchase,
        onSuccess: () {
          Navigator.pop(context);
        },
        onFailure: () {
          // Optional error handling UI
        },
      );
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        imagePath = savedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundColor = AppThemeHelper.scaffoldBackground(context);
    final textColor = AppThemeHelper.textColor(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 1,
        title: Text(
          'Add Item',
          style: AppTextStyles.appBarText.copyWith(color: textColor),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.04),
            child: TextButton(
              onPressed: _saveItem,
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
                const SizedBox(height: 32),
                ProductDetailsSection(
                  supplierController: supplierController,
                  nameController: nameController,
                  skuController: skuController,
                  brandController: brandController,
                ),
                const SizedBox(height: 10),
                OverviewSection(descriptionController: descriptionController),
                const SizedBox(height: 10),
                StockInformationSection(
                  stockController: stockController,
                  reorderController: reorderController,
                ),
                const SizedBox(height: 10),
                PricingInformationSection(
                  sellingPriceController: sellingPriceController,
                  costPriceController: costPriceController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
