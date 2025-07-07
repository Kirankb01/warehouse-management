// product_list_item.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/view/all_items_screen/item_detail_screen/screen/items_details.dart';



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
          color: AppColors.card,
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
            // Product Image or Initial
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              )
                  : null,
            ),

            const SizedBox(width: 16),

            // Item Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.itemName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Brand: ${product.brand}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Stock Badge with Tooltip
            Tooltip(
              message: 'Current stock',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: product.openingStock < product.reorderPoint
                      ? const Color.fromRGBO(244, 67, 54, 0.1) // 🔴 Light red
                      : const Color.fromRGBO(76, 175, 80, 0.1), // 🟢 Light green
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

