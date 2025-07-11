import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
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
      color: AppThemeHelper.cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2_rounded, color: AppThemeHelper.iconColor(context)),
                const SizedBox(width: 8),
                Text(
                  'Product Details',
                  style: AppTextStyles.sectionHeading.copyWith(
                    color: AppThemeHelper.textColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildCustomTextField('Supplier Name', supplierController, isRequired: true),
            buildCustomTextField('Item Name', nameController, isRequired: true),
            buildCustomTextField('SKU', skuController, isRequired: true),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(
                'Brand',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppThemeHelper.textColor(context),
                ),
              ),
            ),
            Consumer<BrandProvider>(
              builder: (context, brandProvider, _) {
                return DropdownButtonFormField<String>(
                  value: selectedBrand,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppThemeHelper.inputFieldColor(context),
                    hintText: 'Select Brand',
                    hintStyle: TextStyle(color: AppThemeHelper.hintTextColor(context)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppThemeHelper.borderColor(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppThemeHelper.borderColor(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppThemeHelper.primaryColor(context), width: 1.5),
                    ),
                  ),
                  dropdownColor: AppThemeHelper.cardColor(context),
                  items: brandProvider.brands.map((brand) {
                    return DropdownMenuItem<String>(
                      value: brand.name,
                      child: Text(
                        brand.name,
                        style: TextStyle(color: AppThemeHelper.textColor(context)),
                      ),
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
