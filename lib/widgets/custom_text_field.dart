// lib/widgets/custom_text_field.dart

import 'package:flutter/material.dart';

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
        TextFormField(
          controller: controller,
          keyboardType: type,
          validator: isRequired
              ? (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (value.startsWith(' ')) return 'Cannot start with space';
            return null;
          }
              : null,

          decoration: const InputDecoration(),
        ),
      ],
    ),
  );
}
