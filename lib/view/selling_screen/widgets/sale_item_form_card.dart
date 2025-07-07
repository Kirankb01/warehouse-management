import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/product.dart';

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
    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: onSelectProduct,
              child: AbsorbPointer(
                child: TextField(
                  controller: item['product'],
                  decoration: const InputDecoration(
                    labelText: 'Select Product',
                    suffixIcon: Icon(Icons.arrow_drop_down),
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
                    decoration: const InputDecoration(labelText: 'Quantity'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: item['price'],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price (₹)'),
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
