import 'package:flutter/material.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/selling_screen/screens/selling_screen.dart';

Widget buildPaymentOption({
  required BuildContext context,
  required String label,
  required PaymentMethod value,
  required PaymentMethod selected,
  required void Function(PaymentMethod?) onChanged,
  required IconData icon,
}) {
  final textColor = AppThemeHelper.textColor(context);

  return RadioListTile<PaymentMethod>(
    value: value,
    groupValue: selected,
    activeColor: Colors.green,
    onChanged: onChanged,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    tileColor: Colors.transparent,
    title: Row(
      children: [
        Icon(icon, size: 20, color: textColor.withAlpha((0.7 * 255).toInt())),

        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 16, color: textColor)),
      ],
    ),
  );
}
