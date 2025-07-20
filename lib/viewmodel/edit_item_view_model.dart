import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';
import 'package:provider/provider.dart';

class EditItemViewModel {
  static void saveUpdatedItem({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Product originalProduct,
    required TextEditingController supplierController,
    required TextEditingController nameController,
    required TextEditingController skuController,
    required TextEditingController stockController,
    required TextEditingController reorderController,
    required TextEditingController sellingController,
    required TextEditingController costController,
    required TextEditingController descriptionController,
    required String? selectedBrand,
    required String? imagePath,
    required Uint8List? imageBytes,
  }) {
    if (!formKey.currentState!.validate()) return;

    final updatedProduct = Product(
      supplierName: supplierController.text.trim(),
      itemName: nameController.text.trim(),
      sku: skuController.text.trim(),
      brand: selectedBrand ?? '',
      openingStock: int.tryParse(stockController.text.trim()) ?? 0,
      reorderPoint: int.tryParse(reorderController.text.trim()) ?? 0,
      sellingPrice: double.tryParse(sellingController.text.trim()) ?? 0.0,
      costPrice: double.tryParse(costController.text.trim()) ?? 0.0,
      imagePath: imagePath,
      description: descriptionController.text.trim(),
      imageBytes: imageBytes
    );

    Provider.of<ProductProvider>(context, listen: false).updateProduct(updatedProduct);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item updated successfully!'),
        backgroundColor: AppColors.summaryContainer,
      ),
    );
  }
}
