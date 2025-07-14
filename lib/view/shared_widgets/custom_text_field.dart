import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';

// using product input
Widget buildCustomTextField(
  String label,
  TextEditingController controller, {
  bool isRequired = false,
  bool multiline = false,
  TextInputType type = TextInputType.text,
  TextCapitalization capitalization = TextCapitalization.none,
}) {
  return Builder(
    builder: (context) {
      final textColor = AppThemeHelper.textColor(context);

      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: controller,
              textInputAction: TextInputAction.next,
              keyboardType: multiline ? TextInputType.multiline : type,
              minLines: multiline ? 3 : 1,
              maxLines: multiline ? null : 1,
              textCapitalization: capitalization,
              style: TextStyle(color: textColor),
              onChanged: (value) {
                final trimmed = value.replaceFirst(RegExp(r'^[ ]+'), '');
                if (controller.text != trimmed) {
                  controller.text = trimmed;
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length),
                  );
                }
              },
              validator:
                  isRequired
                      ? (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      }
                      : null,
              decoration: buildInputDecoration(context, label),
            ),
          ],
        ),
      );
    },
  );
}

InputDecoration buildInputDecoration(BuildContext context, String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      fontSize: 14,
      color: AppThemeHelper.textColor(context).withAlpha(153),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: AppThemeHelper.inputFieldBackground(context),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppThemeHelper.borderColor(context)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppThemeHelper.borderColor(context)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.errorBorder, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.alertColor, width: 1.5),
    ),
  );
}
