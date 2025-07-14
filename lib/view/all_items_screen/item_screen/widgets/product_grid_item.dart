import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/view/all_items_screen/item_detail_screen/screen/items_details.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/all_items_screen/item_screen/widgets/product_image_box.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = product.openingStock < product.reorderPoint;
    final screenWidth = MediaQuery.of(context).size.width;

    double imageSize;
    if (screenWidth >= 1200) {
      imageSize = 130.r;
    } else if (screenWidth >= 800) {
      imageSize = 80.r;
    } else {
      imageSize = 70.r;
    }


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ItemsDetails(product: product)),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: AppThemeHelper.cardColor(context),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProductImageBox(
              itemName: product.itemName,
              imagePath: product.imagePath,
              imageBytes: product.imageBytes,
              size: imageSize,
              borderRadius: 12.r,
              isCircle: false,
            ),

            SizedBox(height: 15.h),

            Text(
              product.itemName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (14.sp).clamp(11.0, 14.0),
                fontWeight: FontWeight.w600,
                color: AppThemeHelper.textColor(context),
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              'Brand: ${product.brand}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: (13.sp).clamp(9.0, 13.0),
                color: AppThemeHelper.textColor(context)
                    .withAlpha((0.6 * 255).toInt()),
              ),
            ),

            SizedBox(height: 18.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isLowStock
                    ? const Color.fromRGBO(244, 67, 54, 0.1)
                    : const Color.fromRGBO(76, 175, 80, 0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                'Qty: ${product.openingStock}',
                style: TextStyle(
                  fontSize: (12.sp).clamp(10.0, 13.0),
                  color: isLowStock
                      ? AppColors.alertColor
                      : AppColors.successColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
