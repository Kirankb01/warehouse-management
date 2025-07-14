import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/settings_screens/user_manual/widgets/manual_section.dart';

class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      ManualSection(
        icon: Icons.add_box_outlined,
        title: 'Add Product',
        description:
            'Tap the "+" button to add a new product. Fill in product name, quantity, category, and description. You can also upload an image.',
      ),
      ManualSection(
        icon: Icons.edit_note_outlined,
        title: 'Edit Product',
        description:
            'Tap on any product to open the edit screen. Update the details and tap "Save" to apply changes.',
      ),
      ManualSection(
        icon: Icons.delete_outline,
        title: 'Delete Product',
        description:
            'Long press a product item to delete it. A confirmation dialog will ensure accidental deletions are avoided.',
      ),
      ManualSection(
        icon: Icons.image_outlined,
        title: 'Image Upload',
        description:
            'When adding or editing a product, tap the image icon to select and upload a product image from your gallery.',
      ),
      ManualSection(
        icon: Icons.search,
        title: 'Search Product',
        description:
            'Use the search bar at the top to filter products by name or category instantly.',
      ),
      ManualSection(
        icon: Icons.grid_view_outlined,
        title: 'List / Grid View Toggle',
        description:
            'Use the toggle button to switch between list view and grid view based on your visual preference.',
      ),
      ManualSection(
        icon: Icons.category_outlined,
        title: 'Manage Categories',
        description:
            'Products are grouped into categories. This helps with filtering and inventory management.',
      ),
      ManualSection(
        icon: Icons.shopping_cart_outlined,
        title: 'Sales Entry',
        description:
            'Tap the floating "Sale" button to reduce stock when an item is sold. You must select the product and enter quantity.',
      ),
      ManualSection(
        icon: Icons.add_shopping_cart_outlined,
        title: 'Purchase Entry',
        description:
            'Tap the floating "Purchase" button to increase stock. Choose the product and enter the quantity received.',
      ),
      ManualSection(
        icon: Icons.history,
        title: 'View Transaction History',
        description:
            'Navigate to the history page (if available) to view recent sales and purchases per product.',
      ),
      ManualSection(
        icon: Icons.storage_rounded,
        title: 'Hive Local Database',
        description:
            'All your data is stored locally using Hive. This means your app works completely offline with fast read/write performance.',
      ),
      ManualSection(
        icon: Icons.lock_outline,
        title: 'Data Privacy',
        description:
            'Your data never leaves your device. Everything is securely stored offline using local storage.',
      ),
    ];

    return Scaffold(
      backgroundColor: AppThemeHelper.scaffoldBackground(context),
      appBar: AppBar(
        title: Text('User Manual', style: AppTextStyles.appBarText),
        backgroundColor: AppThemeHelper.scaffoldBackground(context),
        elevation: 2,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return Card(
            color: AppThemeHelper.cardColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(section.icon, size: 25, color: AppColors.userManualIcon),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          section.description,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: AppThemeHelper.textColor(context),
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
      ),
    );
  }
}
