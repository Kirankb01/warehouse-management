

import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';

Widget buildCustomTextField(
    String label,
    TextEditingController controller, {
      bool isRequired = false,
      TextInputType type = TextInputType.text,
    }) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: type,
          onChanged: (value) {
            final trimmed = value.replaceFirst(RegExp(r'^[ ]+'), '');
            if (controller.text != trimmed) {
              controller.text = trimmed;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          },
          validator: isRequired
              ? (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Required';
            }
            return null;
          }
              : null,
          decoration: buildInputDecoration(label),
        ),
      ],
    ),
  );
}






InputDecoration buildInputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(
      fontSize: 14,
      // fontWeight: FontWeight.w600,
      color: AppColors.onBoardScreenDot,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: AppColors.softBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.lightBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.lightBorder),
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



