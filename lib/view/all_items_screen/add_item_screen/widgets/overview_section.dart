import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/shared_widgets/custom_text_field.dart';

class OverviewSection extends StatelessWidget {
  final TextEditingController descriptionController;

  const OverviewSection({super.key, required this.descriptionController});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppThemeHelper.cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.store_rounded, color: AppThemeHelper.iconColor(context)),
                Text(
                  ' Overview',
                  style: AppTextStyles.sectionHeading.copyWith(
                    color: AppThemeHelper.textColor(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            buildCustomTextField(
              'Description',
              descriptionController,
              type: TextInputType.text,
              isRequired: true,
              multiline: true,
              capitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }
}
