import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/shared_widgets/custom_text_field.dart';
import 'package:warehouse_management/viewmodel/add_item_view_model.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';


class ProductDetailsSection extends StatefulWidget {
  final TextEditingController supplierController;
  final TextEditingController nameController;
  final TextEditingController skuController;
  final TextEditingController brandController;

  const ProductDetailsSection({
    super.key,
    required this.supplierController,
    required this.nameController,
    required this.skuController,
    required this.brandController,
  });

  @override
  State<ProductDetailsSection> createState() => _ProductDetailsSectionState();
}

class _ProductDetailsSectionState extends State<ProductDetailsSection> {
  @override
  Widget build(BuildContext context) {
    final brandProvider = Provider.of<BrandProvider>(context);

    return Card(
      color: AppThemeHelper.cardColor(context),
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
                Icon(Icons.inventory_2_rounded, color: AppThemeHelper.iconColor(context)),
                Text(
                  ' Product Details',
                  style: AppTextStyles.sectionHeading.copyWith(
                    color: AppThemeHelper.textColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildCustomTextField('Supplier Name', widget.supplierController, isRequired: true,capitalization: TextCapitalization.words,),
            buildCustomTextField('Item Name', widget.nameController, isRequired: true,capitalization: TextCapitalization.sentences,),
            buildCustomTextField('SKU', widget.skuController, isRequired: true),
            Padding(
              padding: const EdgeInsets.only(right: 246),
              child: const Text(
                'Brand',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: widget.brandController,
                readOnly: true,
                onTap: () async {
                  final brand = await AddItemViewModel.showBrandBottomSheet(context);
                  if (brand != null) {
                    widget.brandController.text = brand;
                  }
                },
                validator: (value) =>
                value == null || value.isEmpty ? 'Please select a brand' : null,
                decoration: buildInputDecoration(context,'Brand').copyWith(
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
              ),
            ),


            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

}
