import 'package:flutter/material.dart';
import 'package:warehouse_management/view/login_signup_screen/shared_widget/text_field_decoration.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final bool readOnly;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: loginInputDecoration(
        label: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
