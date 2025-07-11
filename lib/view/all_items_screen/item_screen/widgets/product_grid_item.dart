
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/view/all_items_screen/item_detail_screen/screen/items_details.dart';



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/all_items_screen/item_detail_screen/screen/items_details.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = product.openingStock < product.reorderPoint;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItemsDetails(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🖼 Image or Initial Box
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppThemeHelper.scaffoldBackground(context),
                borderRadius: BorderRadius.circular(12),
                image: (product.imagePath != null &&
                    product.imagePath!.isNotEmpty &&
                    File(product.imagePath!).existsSync())
                    ? DecorationImage(
                  image: FileImage(File(product.imagePath!)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: (product.imagePath == null ||
                  product.imagePath!.isEmpty ||
                  !File(product.imagePath!).existsSync())
                  ? Center(
                child: Text(
                  product.itemName.isNotEmpty
                      ? product.itemName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppThemeHelper.textColor(context),
                  ),
                ),
              )
                  : null,
            ),

            const SizedBox(height: 15),

            // 📝 Item name
            Text(
              product.itemName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppThemeHelper.textColor(context),
              ),
            ),

            const SizedBox(height: 4),

            // 🏷️ Brand
            Text(
              product.brand,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: AppThemeHelper.textColor(context).withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 18),

            // 📦 Qty badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isLowStock
                    ? const Color.fromRGBO(244, 67, 54, 0.1)
                    : const Color.fromRGBO(76, 175, 80, 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Qty: ${product.openingStock}',
                style: TextStyle(
                  fontSize: 12,
                  color: isLowStock
                      ? AppColors.alertColor
                      : AppColors.successColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
