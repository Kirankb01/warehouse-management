import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeHelper.appBarBackground(context),
      appBar: AppBar(
        backgroundColor: AppThemeHelper.appBarBackground(context),
        title: Text('Notifications', style: AppTextStyles.appBarText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, _) {
            // Get products that need reordering
            final lowStockItems = productProvider.products
                .where((p) => p.openingStock <= p.reorderPoint)
                .toList();

            if (lowStockItems.isEmpty) {
              return const Center(
                child: Text(
                  'All items are in stock ✅',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: lowStockItems.length,
              itemBuilder: (context, index) {
                final product = lowStockItems[index];

                return Card(
                  color: AppThemeHelper.cardColor(context),
                  child: ListTile(
                    leading: const Icon(
                      Icons.warning,
                      color: AppColors.alertColor,
                    ),
                    title: Text(
                      product.itemName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Only ${product.openingStock} left in stock! Reorder point: ${product.reorderPoint}',
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
