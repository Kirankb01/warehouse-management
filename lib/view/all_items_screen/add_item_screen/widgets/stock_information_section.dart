import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
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
                const Icon(Icons.store_rounded),
                Text(' Stock Information', style: AppTextStyles.sectionHeading),
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
