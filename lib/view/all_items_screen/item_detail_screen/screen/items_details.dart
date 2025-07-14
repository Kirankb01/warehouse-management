import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/view/all_items_screen/edit_item_screen/screen/edit_item.dart';
import 'package:warehouse_management/view/all_items_screen/item_detail_screen/widgets/info_row.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';
import '../../../../utils/helpers/item_sales_linechart_helper.dart';
import '../../../shared_widgets/line_chart.dart';

class ItemsDetails extends StatefulWidget {
  final Product product;

  const ItemsDetails({super.key, required this.product});

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final product = provider.products.firstWhere(
              (p) => p.sku == widget.product.sku,
          orElse: () => widget.product,
        );

        final fileExists =
            product.imagePath != null &&
                product.imagePath!.isNotEmpty &&
                File(product.imagePath!).existsSync();

        final Map<String, double> salesData = ItemSalesHelper.computeItemSales(
          'This Month',
          hiveBoxName: 'salesBox',
          itemSku: product.sku,
        );

        return Scaffold(
          backgroundColor: AppThemeHelper.scaffoldBackground(context),
          appBar: AppBar(
            title: Text(
              'Item Details',
              style: AppTextStyles.appBarText.copyWith(
                fontSize: size.width < 600 ? 20 : 26,
              ),
            ),
            backgroundColor: AppThemeHelper.scaffoldBackground(context),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 5),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Icon(Icons.delete, color: AppThemeHelper.iconColor(context)),
                      onTap: () async {
                        final confirmed = await showDeleteBottomSheet(
                          context,
                          product.itemName,
                        );
                        if (confirmed) {
                          await Provider.of<ProductProvider>(
                            context,
                            listen: false,
                          ).deleteProduct(product.sku);

                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      },
                    ),
                    SizedBox(width: size.width * 0.08),
                    GestureDetector(
                      child: Icon(Icons.edit, color: AppThemeHelper.iconColor(context)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditItem(product: product),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    color: AppThemeHelper.cardColor(context),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: !kIsWeb && fileExists
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(product.imagePath!),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                          : product.imageBytes != null && kIsWeb
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          product.imageBytes!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                          : CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.addImage,
                        child: Text(
                          product.itemName[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppThemeHelper.textColor(context),
                          ),
                        ),
                      ),
                      title: Text(
                        product.itemName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppThemeHelper.textColor(context),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Text("Available Stock: ", style: TextStyle(color: AppThemeHelper.textColor(context))),
                            Text(
                              '${product.openingStock}',
                              style: AppTextStyles.itemDetailText.copyWith(color: AppThemeHelper.textColor(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: size.width,
                  color: AppThemeHelper.cardColor(context),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Overview',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: double.infinity,
                          minHeight: screenHeight * 0.15,
                        ),
                        child: Card(
                          color: AppThemeHelper.cardColor(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppThemeHelper.textColor(context),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  product.description?.isNotEmpty == true
                                      ? product.description!
                                      : 'No description available.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppThemeHelper.textColor(context).withAlpha((0.87 * 255).toInt()),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        color: AppThemeHelper.cardColor(context),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              infoRow("Reorder Point:", '${product.reorderPoint}'),
                              const SizedBox(height: 10),
                              infoRow("Brand:", product.brand),
                              const SizedBox(height: 10),
                              infoRow("SKU#:", product.sku),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        color: AppThemeHelper.cardColor(context),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              infoRow("Selling Price (INR):", '₹ ${product.sellingPrice}'),
                              const SizedBox(height: 10),
                              infoRow("Cost Price (INR):", '₹ ${product.costPrice}'),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      MonthlySalesChart(
                        monthlySales: salesData,
                        title: 'Sales Performance (Monthly)',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
