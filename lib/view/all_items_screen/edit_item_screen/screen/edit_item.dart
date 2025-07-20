import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/all_items_screen/edit_item_screen/widgets/overview_section_edit.dart';
import 'package:warehouse_management/view/all_items_screen/edit_item_screen/widgets/pricing_information_section_edit.dart';
import 'package:warehouse_management/view/all_items_screen/edit_item_screen/widgets/product_details_section_edit.dart';
import 'package:warehouse_management/view/all_items_screen/edit_item_screen/widgets/stock_information_section_edit.dart';
import 'package:warehouse_management/view/shared_widgets/image_picker_box.dart';
import 'package:warehouse_management/viewmodel/edit_item_view_model.dart';

class EditItem extends StatefulWidget {
  final Product product;

  const EditItem({super.key, required this.product});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController supplierController;
  late TextEditingController nameController;
  late TextEditingController skuController;
  late TextEditingController stockController;
  late TextEditingController reorderController;
  late TextEditingController sellingController;
  late TextEditingController costController;
  late TextEditingController descriptionController;

  Uint8List? _imageBytes;

  String? _imagePath;
  String? selectedBrand;

  @override
  void initState() {
    super.initState();
    supplierController = TextEditingController(
      text: widget.product.supplierName,
    );
    nameController = TextEditingController(text: widget.product.itemName);
    skuController = TextEditingController(text: widget.product.sku);
    descriptionController = TextEditingController(
      text: widget.product.description,
    );
    stockController = TextEditingController(
      text: widget.product.openingStock.toString(),
    );
    reorderController = TextEditingController(
      text: widget.product.reorderPoint.toString(),
    );
    sellingController = TextEditingController(
      text: widget.product.sellingPrice.toString(),
    );
    costController = TextEditingController(
      text: widget.product.costPrice.toString(),
    );
    _imagePath = widget.product.imagePath;
    _imageBytes = widget.product.imageBytes;
    selectedBrand = widget.product.brand;
  }

  @override
  void dispose() {
    supplierController.dispose();
    nameController.dispose();
    skuController.dispose();
    stockController.dispose();
    reorderController.dispose();
    sellingController.dispose();
    costController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      if (kIsWeb) {
        setState(() {
          _imageBytes = result.files.single.bytes!;
          _imagePath = null;
        });
      } else {
        final path = result.files.single.path;
        if (path != null) {
          final savedImage = await File(path).copy(
            '${(await getApplicationDocumentsDirectory()).path}/${result.files.single.name}',
          );
          setState(() {
            _imagePath = savedImage.path;
            _imageBytes = null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppThemeHelper.scaffoldBackground(context),
      appBar: AppBar(
        title: Text(
          'Edit Item',
          style: AppTextStyles.appBarText.copyWith(
            fontSize: size.width < 600 ? 20 : 26,
          ),
        ),
        backgroundColor: AppThemeHelper.scaffoldBackground(context),
        actions: [
          GestureDetector(
            onTap: () {
              EditItemViewModel.saveUpdatedItem(
                context: context,
                formKey: _formKey,
                originalProduct: widget.product,
                supplierController: supplierController,
                nameController: nameController,
                skuController: skuController,
                stockController: stockController,
                reorderController: reorderController,
                sellingController: sellingController,
                costController: costController,
                descriptionController: descriptionController,
                selectedBrand: selectedBrand,
                imagePath: _imagePath,
                imageBytes: _imageBytes,
              );
            },

            child: Padding(
              padding: EdgeInsets.only(right: size.width * 0.05),
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: size.width < 600 ? 16 : 22,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: ImagePickerBox(
                    imagePath: _imagePath,
                    imageBytes: _imageBytes,
                    onTap: _pickImage,
                  ),
                ),
                const SizedBox(height: 40),
                ProductDetailsSectionEdit(
                  supplierController: supplierController,
                  nameController: nameController,
                  skuController: skuController,
                  brandController: TextEditingController(text: selectedBrand),
                  selectedBrand: selectedBrand,
                  onBrandChanged:
                      (value) => setState(() => selectedBrand = value),
                ),
                const SizedBox(height: 15),
                OverviewSectionEdit(
                  descriptionController: descriptionController,
                ),
                const SizedBox(height: 15),
                StockInformationSectionEdit(
                  stockController: stockController,
                  reorderController: reorderController,
                ),
                const SizedBox(height: 15),
                PricingInformationSectionEdit(
                  sellingController: sellingController,
                  costController: costController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
