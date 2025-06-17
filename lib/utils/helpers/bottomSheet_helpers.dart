import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';

Future<bool> showDeleteBottomSheet(BuildContext context, String itemName) async {
  final result = await showModalBottomSheet<bool>(
    backgroundColor: AppColors.pureWhite,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete Item?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text('Are you sure you want to delete "$itemName"?'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.alertColor,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete',style: TextStyle(color: AppColors.pureWhite),),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );

  return result ?? false;
}









void showBrandFilterDialog({
  required BuildContext context,
  required String? selectedBrand,
  required Function(String? brand) onBrandSelected,
}) {
  final brandProvider = Provider.of<BrandProvider>(context, listen: false);
  final uniqueBrands = brandProvider.brands.map((b) => b.name).toList();

  showModalBottomSheet(
    backgroundColor: AppColors.pureWhite,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            const Text(
              'Available Brands',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...uniqueBrands.map(
                  (brand) => ListTile(
                title: Text(brand),
                selected: selectedBrand == brand,
                onTap: () {
                  Navigator.pop(context);
                  onBrandSelected(brand);
                },
              ),
            ),
            ListTile(
              title: const Text('Clear Brand Filter'),
              onTap: () {
                Navigator.pop(context);
                onBrandSelected(null);
              },
            ),
          ],
        ),
      );
    },
  );
}




