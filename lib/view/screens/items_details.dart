import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/view/screens/edit_item.dart';
import 'package:warehouse_management/view/widgets/info_row.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';

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

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              'Item Details',
              style: AppTextStyles.appBarText.copyWith(
                fontSize: size.width < 600 ? 20 : 26,
              ),
            ),
            backgroundColor: AppColors.background,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 5),
                child: Row(
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.delete),
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
                      child: const Icon(Icons.edit),
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
                    color: AppColors.card,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading:
                          fileExists
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(product.imagePath!),
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
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.pureBlack,
                                  ),
                                ),
                              ),
                      title: Text(
                        product.itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Text("Available Stock: "),
                            Text(
                              '${product.openingStock}',
                              style: AppTextStyles.itemDetailText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Overview Section Title
                Container(
                  height: 70,
                  width: size.width,
                  color: AppColors.pureWhite,
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
                      Card(
                        color: AppColors.card,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              infoRow(
                                "Reorder Point:",
                                '${product.reorderPoint}',
                              ),
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
                        color: AppColors.card,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              infoRow(
                                "Selling Price (INR):",
                                '₹ ${product.sellingPrice}',
                              ),
                              const SizedBox(height: 10),
                              infoRow(
                                "Cost Price (INR):",
                                '₹ ${product.costPrice}',
                              ),
                            ],
                          ),
                        ),
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
