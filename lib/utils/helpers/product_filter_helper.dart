import 'package:warehouse_management/models/product.dart';
import 'package:flutter/material.dart';

import 'package:warehouse_management/utils/helpers/bottomSheet_helpers.dart';


import 'package:flutter/material.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/utils/helpers.dart'; // for showBrandFilterDialog

void showFilterOptions({
  required BuildContext context,
  required String? selectedBrand,
  required String sortOption,
  required Function(String? brand, String sortOption) onFilterChanged,
}) {
  showModalBottomSheet(
    backgroundColor: AppThemeHelper.dialogBackground(context),
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      final textColor = AppThemeHelper.textColor(context);

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          children: [
            Text(
              'Filter Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 15),
            ListTile(
              title: Text('Sort by Name (A-Z)', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.pop(context);
                onFilterChanged(selectedBrand, 'name_asc');
              },
              selected: sortOption == 'name_asc',
              selectedTileColor: AppThemeHelper.inputFieldBackground(context),
            ),
            ListTile(
              title: Text('Sort by Stock (High to Low)', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.pop(context);
                onFilterChanged(selectedBrand, 'stock_desc');
              },
              selected: sortOption == 'stock_desc',
              selectedTileColor: AppThemeHelper.inputFieldBackground(context),
            ),
            ListTile(
              title: Text('Low Stock (< 10)', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.pop(context);
                onFilterChanged(selectedBrand, 'low_stock');
              },
              selected: sortOption == 'low_stock',
              selectedTileColor: AppThemeHelper.inputFieldBackground(context),
            ),
            ListTile(
              title: Text('Filter by Brand', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.pop(context);
                showBrandFilterDialog(
                  context: context,
                  selectedBrand: selectedBrand,
                  onBrandSelected: (brand) {
                    onFilterChanged(brand, sortOption);
                  },
                );
              },
            ),
            ListTile(
              title: Text('Clear Filters', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.pop(context);
                onFilterChanged(null, '');
              },
            ),
          ],
        ),
      );
    },
  );
}





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






