import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

List<Product> filterAndSortProducts({
  required List<Product> products,
  String? selectedBrand,
  String sortOption = '',
  String searchQuery = '',
}) {
  List<Product> filtered = [...products];

  // Filter by brand
  if (selectedBrand != null) {
    filtered = filtered.where((p) => p.brand == selectedBrand).toList();
  }

  // Sorting
  switch (sortOption) {
    case 'name_asc':
      filtered.sort(
            (a, b) =>
            a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase()),
      );
      break;
    case 'stock_desc':
      filtered.sort((b, a) => a.openingStock.compareTo(b.openingStock));
      break;
    case 'low_stock':
      filtered = filtered.where((p) => p.openingStock < 10).toList();
      break;
  }

  // Search
  if (searchQuery.isNotEmpty) {
    final query = searchQuery.toLowerCase();
    filtered = filtered
        .where((p) =>
    p.itemName.toLowerCase().contains(query) ||
        p.sku.toLowerCase().contains(query))
        .toList();
  }

  return filtered;
}



void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String actionText,
  required VoidCallback onActionPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onActionPressed();
            },
            child: Text(actionText,style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        ],
      );
    },
  );
}



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




final ButtonStyle loginButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  elevation: 4,
);

