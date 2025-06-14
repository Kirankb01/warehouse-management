import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/providers/product_provider.dart';



class EditItem extends StatefulWidget {
  final Product product;

  const EditItem({super.key, required this.product});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {

  late TextEditingController supplier_nameController;
  late TextEditingController nameController;
  late TextEditingController skuController;
  late TextEditingController brandController;
  late TextEditingController stockController;
  late TextEditingController reorderController;
  late TextEditingController sellingController;
  late TextEditingController costController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    supplier_nameController = TextEditingController(text: widget.product.supplierName);
    nameController = TextEditingController(text: widget.product.itemName);
    skuController = TextEditingController(text: widget.product.sku);
    brandController = TextEditingController(text: widget.product.brand);
    stockController = TextEditingController(text: widget.product.openingStock.toString());
    reorderController = TextEditingController(text: widget.product.reorderPoint.toString());
    sellingController = TextEditingController(text: widget.product.sellingPrice.toString());
    costController = TextEditingController(text: widget.product.costPrice.toString());
    _imagePath = widget.product.imagePath;

  }

  @override
  void dispose() {
    nameController.dispose();
    skuController.dispose();
    brandController.dispose();
    stockController.dispose();
    reorderController.dispose();
    sellingController.dispose();
    costController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Edit Item',
          style: AppTextStyles.appBarText.copyWith(
            fontSize: size.width < 600 ? 20 : 26,
          ),
        ),
        backgroundColor: AppColors.background,
        actions: [
          GestureDetector(
            onTap: () {
              final updatedProduct = Product(
                supplierName: supplier_nameController.text,
                itemName: nameController.text,
                sku: skuController.text,
                brand: brandController.text,
                openingStock: int.tryParse(stockController.text) ?? 0,
                reorderPoint: int.tryParse(reorderController.text) ?? 0,
                sellingPrice: double.tryParse(sellingController.text) ?? 0.0,
                costPrice: double.tryParse(costController.text) ?? 0.0,
                imagePath: _imagePath,
              );

              // Use Provider to update
              Provider.of<ProductProvider>(context, listen: false)
                  .updateProduct(updatedProduct);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blueGrey,
                  content: Text('Item saved successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },

            child: Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 22,
                ),
              ),
            ),
          ),

        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: size.height * 0.16,
                    width: size.width * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white,
                        width: size.width * 0.015,
                      ),
                      color: Color(0xFFE3EAF6),
                      image: _imagePath != null
                          ? DecorationImage(
                        image: FileImage(File(_imagePath!)),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _imagePath == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt_rounded, size: 35),
                        Text('Add Image'),
                      ],
                    )
                        : null,
                  ),
                ),

              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Supplier Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                          controller: supplier_nameController
                      ),
                      Text(
                        'Item Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                          controller: nameController
                      ),
                      SizedBox(height: 15),
                      Text(
                        'SKU',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                          controller: skuController
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Brand',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                          controller: brandController
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Opening Stock',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: '0.0',
                                  ),
                                  controller: stockController,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reorder Point',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: '0.0',
                                  ),
                                  controller: reorderController,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selling Price',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: '0.0',
                              ),
                              controller: sellingController,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cost Price',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: '0.0',
                              ),
                              controller: costController,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}
