import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/models/purchase.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';
import 'package:warehouse_management/viewmodel/summary_view_model.dart';
import 'package:warehouse_management/constants/app_colors.dart';

class AddItemViewModel {
  static Future<void> saveItem({
    required BuildContext context,
    required Product product,
    required Purchase purchase,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    try {
      // save to Hive
      final success = await AddItemViewModel().saveItemToHive(
        product,
        purchase,
      );

      if (!context.mounted) return;

      if (success) {
        Provider.of<ProductProvider>(
          context,
          listen: false,
        ).addProduct(product);
        Provider.of<SummaryViewModel>(context, listen: false).loadSummaryData();
        onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item saved and purchase recorded!'),
            backgroundColor: AppColors.successColor,
          ),
        );
      } else {
        onFailure();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving item'),
            backgroundColor: AppColors.alertColor,
          ),
        );
      }
    } catch (e) {
      onFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exception: ${e.toString()}'),
          backgroundColor: AppColors.alertColor,
        ),
      );
    }
  }

  Future<bool> saveItemToHive(Product newProduct, Purchase newPurchase) async {
    try {
      final purchaseBox = Hive.box<Purchase>('purchases');
      await purchaseBox.add(newPurchase);
      return true;
    } catch (error) {
      debugPrint("Error in saveItemToHive: $error");
      return false;
    }
  }

  // brand selecting logic in add_item

  static Future<String?> showBrandBottomSheet(BuildContext context) async {
    final brandProvider = Provider.of<BrandProvider>(context, listen: false);
    final searchController = TextEditingController();
    List<String> filteredBrands = List.from(
      brandProvider.brands.map((b) => b.name),
    );

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppThemeHelper.dialogBackground(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        style: TextStyle(
                          color: AppThemeHelper.textColor(context),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search brand...',
                          hintStyle: TextStyle(
                            color: AppThemeHelper.textColor(
                              context,
                            ).withAlpha((0.6 * 255).toInt()),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppThemeHelper.iconColor(context),
                          ),
                          filled: true,
                          fillColor: AppThemeHelper.inputFieldBackground(
                            context,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppThemeHelper.borderColor(context),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppThemeHelper.borderColor(context),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            filteredBrands =
                                brandProvider.brands
                                    .where(
                                      (b) => b.name.toLowerCase().contains(
                                        value.toLowerCase(),
                                      ),
                                    )
                                    .map((b) => b.name)
                                    .toList();
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredBrands.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: Text(
                                filteredBrands[i],
                                style: TextStyle(
                                  color: AppThemeHelper.textColor(context),
                                ),
                              ),
                              onTap:
                                  () =>
                                      Navigator.pop(context, filteredBrands[i]),
                            );
                          },
                        ),
                      ),
                      const Divider(),
                      TextButton.icon(
                        onPressed: () async {
                          final newBrand = await showAddBrandDialog(context);
                          if (newBrand != null && newBrand.trim().isNotEmpty) {
                            brandProvider.addBrand(newBrand.trim());
                            setModalState(() {
                              filteredBrands =
                                  brandProvider.brands
                                      .map((b) => b.name)
                                      .toList();
                            });
                            Navigator.pop(context, newBrand.trim());
                          }
                        },
                        icon: Icon(
                          Icons.add,
                          color: AppThemeHelper.iconColor(context),
                        ),
                        label: Text(
                          'Add New Brand',
                          style: TextStyle(
                            color: AppThemeHelper.textColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // add brand dialog_box

  static Future<String?> showAddBrandDialog(BuildContext context) async {
    final TextEditingController newBrandController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppThemeHelper.dialogBackground(context),
          title: const Text('Add New Brand'),
          content: TextField(
            controller: newBrandController,
            decoration: const InputDecoration(hintText: 'Enter brand name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, newBrandController.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
