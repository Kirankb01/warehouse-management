import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';

class SaleItemFormCard extends StatelessWidget {
  final int index;
  final List<Map<String, TextEditingController>> items;
  final List<Product> allProducts;
  final VoidCallback onRemove;
  final VoidCallback onSelectProduct;

  const SaleItemFormCard({
    super.key,
    required this.index,
    required this.items,
    required this.allProducts,
    required this.onRemove,
    required this.onSelectProduct,
  });

  @override
  Widget build(BuildContext context) {
    final item = items[index];
    final textColor = AppThemeHelper.textColor(context);

    return Card(
      color: AppThemeHelper.cardColor(context),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: onSelectProduct,
              child: AbsorbPointer(
                child: TextField(
                  controller: item['product'],
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Select Product',
                    labelStyle: TextStyle(color: textColor.withAlpha((0.7 * 255).toInt())),
                    suffixIcon: Icon(Icons.arrow_drop_down, color: textColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.lightBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: item['quantity'],
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      labelStyle: TextStyle(color: textColor.withAlpha((0.7 * 255).toInt())),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.lightBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: item['price'],
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Price (₹)',
                      labelStyle: TextStyle(
                        color: textColor.withAlpha((0.7 * 255).toInt()),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.lightBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                if (items.length > 1)
                  IconButton(
                    onPressed: onRemove,
                    icon: Icon(Icons.delete, color: AppColors.alertColor),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
