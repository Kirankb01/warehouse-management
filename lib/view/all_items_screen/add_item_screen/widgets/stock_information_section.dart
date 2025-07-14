import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/shared_widgets/custom_text_field.dart';

class StockInformationSection extends StatelessWidget {
  final TextEditingController stockController;
  final TextEditingController reorderController;

  const StockInformationSection({
    super.key,
    required this.stockController,
    required this.reorderController,
  });

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.store_rounded, color: AppThemeHelper.iconColor(context)),
                Text(
                  ' Stock Information',
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
          ],
        ),
      ),
    );
  }
}
