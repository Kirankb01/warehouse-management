
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/view/screens/items_details.dart';



class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasImage = product.imagePath != null &&
        product.imagePath!.isNotEmpty &&
        File(product.imagePath!).existsSync();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => ItemsDetails(product: product)),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: hasImage ? FileImage(File(product.imagePath!)) : null,
                child: !hasImage
                    ? Text(
                  product.itemName.isNotEmpty
                      ? product.itemName[0].toUpperCase()
                      : '?',
                )
                    : null,
              ),
              const SizedBox(height: 8),
              Text(product.itemName),
              Text('Stock: ${product.openingStock}'),
              Text('Brand: ${product.brand}'),
            ],
          ),
        ),
      ),
    );
  }
}
