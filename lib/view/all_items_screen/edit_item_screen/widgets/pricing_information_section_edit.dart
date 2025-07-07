import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/view/shared_widgets/custom_text_field.dart';


class PricingInformationSectionEdit extends StatelessWidget {
  final TextEditingController sellingController;
  final TextEditingController costController;

  const PricingInformationSectionEdit({
    super.key,
    required this.sellingController,
    required this.costController,
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
    );
  }
}
