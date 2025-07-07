import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/view/shared_widgets/custom_text_field.dart';

class PricingInformationSection extends StatelessWidget {
  final TextEditingController sellingPriceController;
  final TextEditingController costPriceController;

  const PricingInformationSection({
    super.key,
    required this.sellingPriceController,
    required this.costPriceController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                const Icon(Icons.price_change_rounded),
                Text(' Pricing Information', style: AppTextStyles.sectionHeading),
              ],
            ),
            const SizedBox(height: 20),
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
    );
  }
}
