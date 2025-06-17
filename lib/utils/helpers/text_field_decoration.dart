import 'package:flutter/material.dart';

InputDecoration loginInputDecoration({
  required String label,
  required IconData prefixIcon,
  Widget? suffixIcon, // Accepting a Widget instead of IconData
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 14, color: Colors.white),
    filled: true,
    fillColor: const Color(0xFF3B4252),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    prefixIcon: Icon(prefixIcon, color: Colors.white70),
    suffixIcon: suffixIcon, // Passing the dynamic widget
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 0.5),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFD9A441), width: 2),
    ),
  );
}
