import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/view/shared_widgets/custom_text_field.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';


class ProductDetailsSectionEdit extends StatelessWidget {
  final TextEditingController supplierController;
  final TextEditingController nameController;
  final TextEditingController skuController;
  final TextEditingController brandController;
  final String? selectedBrand;
  final Function(String?) onBrandChanged;

  const ProductDetailsSectionEdit({
    super.key,
    required this.supplierController,
    required this.nameController,
    required this.skuController,
    required this.brandController,
    required this.selectedBrand,
    required this.onBrandChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.inventory_2_rounded),
                SizedBox(width: 8),
                Text('Product Details', style: AppTextStyles.sectionHeading),
              ],
            ),
            const SizedBox(height: 20),
            buildCustomTextField('Supplier Name', supplierController, isRequired: true),
            buildCustomTextField('Item Name', nameController, isRequired: true),
            buildCustomTextField('SKU', skuController, isRequired: true),
            const Padding(
              padding: EdgeInsets.only(right: 246),
              child: Text('Brand', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Consumer<BrandProvider>(
              builder: (context, brandProvider, _) {
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
                  items: brandProvider.brands.map((brand) {
                    return DropdownMenuItem<String>(
                      value: brand.name,
                      child: Text(brand.name),
                    );
                  }).toList(),
                  onChanged: onBrandChanged,
                  validator: (value) => value == null || value.isEmpty ? 'Please select a brand' : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
