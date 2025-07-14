import 'package:flutter/material.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/all_items_screen/item_detail_screen/screen/items_details.dart';
import 'package:warehouse_management/view/all_items_screen/item_screen/widgets/product_image_box.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItemsDetails(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppThemeHelper.cardColor(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ProductImageBox(
              itemName: product.itemName,
              imagePath: product.imagePath,
              imageBytes: product.imageBytes,
              size: 52,
              isCircle: true,
              isGridView: false,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.itemName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppThemeHelper.textColor(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Brand: ${product.brand}",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppThemeHelper.textColor(context).withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),

            Tooltip(
              message: 'Current stock',
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: product.openingStock < product.reorderPoint
                      ? const Color.fromRGBO(244, 67, 54, 0.1)
                      : const Color.fromRGBO(76, 175, 80, 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${product.openingStock}',
                  style: TextStyle(
                    color: product.openingStock < product.reorderPoint
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
