import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/utils/helpers/bottomSheet_helpers.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';
import '../../view/selling_screen/screens/selling_screen.dart';

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
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Consumer<BrandProvider>(
                  builder: (_, provider, __) {
                    final query = searchController.text.toLowerCase();
                    final filteredBrands = provider.brands
                        .where((brand) =>
                        brand.name.toLowerCase().contains(query))
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
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  title: Text(
                                    brand.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    onPressed: () async {
                                      final confirmed =
                                      await showDeleteBottomSheet(
                                          context, brand.name);
                                      if (confirmed) {
                                        await provider.removeBrand(brand.name);
                                        setState(() {});
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
              ),
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




Future<bool> showConfirmSaleDialog(
    BuildContext context, {
      required PaymentMethod selectedPayment,
    }) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.white ,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_rounded,
              size: 50,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            Text(
              "Confirm Sale",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Are you sure you want to submit this sale?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Icon(Icons.payment_rounded, color: Colors.blue),
                  Text(
                    selectedPayment == PaymentMethod.gpay
                        ? 'Payment Method: GPay'
                        : 'Payment Method: Cash in Hand',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),

            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.check),
                    label: Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: TextStyle(fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ) ??
      false;
}



