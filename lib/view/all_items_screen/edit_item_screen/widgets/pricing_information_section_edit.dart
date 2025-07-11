import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
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
      color: AppThemeHelper.cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.price_change_rounded, color: AppThemeHelper.iconColor(context)),
                const SizedBox(width: 8),
                Text(
                  'Pricing Information',
                  style: AppTextStyles.sectionHeading.copyWith(
                    color: AppThemeHelper.textColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: buildCustomTextField(
                    'Selling Price',
                    sellingController,
                    type: TextInputType.number,
                    isRequired: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildCustomTextField(
                    'Cost Price',
                    costController,
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
