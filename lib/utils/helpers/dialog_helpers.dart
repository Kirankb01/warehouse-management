import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/utils/helpers/bottomSheet_helpers.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String actionText,
  required VoidCallback onActionPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onActionPressed();
            },
            child: Text(actionText,style: TextStyle(fontWeight: FontWeight.bold),),
          ),
        ],
      );
    },
  );
}





void showAddBrandDialog(BuildContext context) {
  final brandController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Add New Brand'),
      content: TextField(
        controller: brandController,
        decoration: const InputDecoration(hintText: 'Enter brand name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () async {
            final brandName = brandController.text.trim();
            if (brandName.isNotEmpty) {
              await Provider.of<BrandProvider>(
                context,
                listen: false,
              ).addBrand(brandName);
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Add',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}




void showDeleteBrandDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController searchController = TextEditingController();

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            contentPadding: const EdgeInsets.all(20),
            title: const Text(
              'Delete Brand',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            content: Consumer<BrandProvider>(
              builder: (_, provider, __) {
                final query = searchController.text.toLowerCase();
                final filteredBrands = provider.brands
                    .where((brand) => brand.name.toLowerCase().contains(query))
                    .toList();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔍 Search Field
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search brand...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                        )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // 📜 Brand List
                    if (filteredBrands.isEmpty)
                      const Text(
                        'No matching brands found.',
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      SizedBox(
                        height: 200,
                        width: 300,
                        child: ListView.separated(
                          itemCount: filteredBrands.length,
                          separatorBuilder: (_, __) => Divider(
                            color: Colors.grey.shade300,
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final brand = filteredBrands[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                              title: Text(
                                brand.name,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () async {
                                  final confirmed = await showDeleteBottomSheet(context, brand.name);
                                  if (confirmed) {
                                    await provider.removeBrand(brand.name);
                                    setState(() {}); // refresh list
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}



Future<bool> showConfirmSaleDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          Icon(Icons.shopping_cart_checkout, color: Colors.blue),
          SizedBox(width: 8),
          Text("Confirm Sale"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Are you sure you want to submit this sale?"),
          SizedBox(height: 8),
          Text(
            "This action will finalize the transaction and cannot be undone.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: Icon(Icons.check),
          label: Text("Submit"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );

  return result ?? false;
}

