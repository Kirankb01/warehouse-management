// product_list_item.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/view/screens/items_details.dart';



class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => ItemsDetails(product: product)),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        elevation: 2,
        child: SizedBox(
          height: 80,
          child: ListTile(
            title: Text(product.itemName),
            leading: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: CircleAvatar(
                backgroundImage: product.imagePath != null &&
                    product.imagePath!.isNotEmpty
                    ? FileImage(File(product.imagePath!))
                    : null,
                child: product.imagePath == null ||
                    product.imagePath!.isEmpty
                    ? Text(product.itemName.isNotEmpty
                    ? product.itemName[0]
                    : '?')
                    : null,
              ),
            ),
            subtitle: Text('Brand: ${product.brand}'),
            trailing: Text(
              product.openingStock.toString(),
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
