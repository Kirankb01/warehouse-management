// lib/widgets/info_row.dart

import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';


Widget infoRow(String label, String value) {
  return Row(
    children: [
      Text(label),
      const SizedBox(width: 5),
      Expanded(
        child: Text(
          value,
          style: AppTextStyles.itemDetailText,
        ),
      ),
    ],
  );
}
