import 'package:flutter/material.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/all_items_screen/add_item_screen/screen/add_item.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';

class AddOptionsPopupMenu extends StatelessWidget {
  final ProductProvider productProvider;
  final VoidCallback onItemAdded;

  const AddOptionsPopupMenu({
    super.key,
    required this.productProvider,
    required this.onItemAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: PopupMenuButton<String>(
        color: AppThemeHelper.cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: Icon(Icons.add, color: AppThemeHelper.iconColor(context)),
        tooltip: 'Add options',
        onSelected: (value) {
          if (value == 'item') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddItem()),
            ).then((_) {
              productProvider.loadProducts();
              onItemAdded();
            });
          } else if (value == 'brand') {
            showAddBrandDialog(context);
          } else if (value == 'delete_brand') {
            showDeleteBrandDialog(context);
          }
        },
        itemBuilder: (context) => [
          _buildMenuItem(context, 'item', Icons.inventory_2_outlined, 'Add New Item'),
          _buildMenuItem(context, 'brand', Icons.branding_watermark, 'Add New Brand'),
          _buildMenuItem(context, 'delete_brand', Icons.delete_forever, 'Delete Brand'),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(BuildContext context, String value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: AppThemeHelper.popupMenuIconColor(context)),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}
