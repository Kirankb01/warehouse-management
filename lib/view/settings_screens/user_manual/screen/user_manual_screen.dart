import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/settings_screens/user_manual/widgets/instruction_card.dart';
import 'package:warehouse_management/view/settings_screens/user_manual/widgets/section_title.dart';

class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bgColor = AppThemeHelper.scaffoldBackground(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('User Manual', style: AppTextStyles.appBarText),
      ),
      backgroundColor: bgColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          sectionTitle(Icons.add,'Add New Item'),
          instructionCard(
            context,
            'Navigate to "Items" and click the "+" icon.\n'
            'Fill in item details including SKU, brand, price, etc.\n'
            'Tap "Save" to add the item to your warehouse.',
          ),

          sectionTitle(Icons.edit_note_outlined,'Edit Item'),
          instructionCard(
            context,
            'Tap on any listed item.\n'
            'Click the edit icon to modify item details.\n'
            'Save the changes after editing.',
          ),

          sectionTitle(Icons.point_of_sale,'Record Sale'),
          instructionCard(
            context,
            'Go to the "Sell" tab.\n'
            'Add customer name and product details.\n'
            'Choose payment method and submit the sale.',
          ),

          sectionTitle(Icons.download_outlined,'Record Purchase'),
          instructionCard(
            context,
            'When adding a new item with stock, a purchase record is saved automatically.\n'
            'You can later view purchase history from the Purchase screen.',
          ),

          sectionTitle(Icons.bar_chart,'Summary & Reports'),
          instructionCard(
            context,
            'View total sales, purchases, profit/loss with filters by date/month/year.\n'
            'Charts and data help analyze performance.',
          ),

          sectionTitle(Icons.apartment,'Organization Profile'),
          instructionCard(
            context,
            'Set your business name, contact details, logo, timezone, etc.\n'
            'These details will be shown on invoices and reports.',
          ),

          sectionTitle(Icons.settings,'Settings & Customization'),
          instructionCard(
            context,
            'Switch between light/dark mode.\n'
            'Choose currency, country, language, and date format.',
          ),
        ],
      ),
    );
  }
}
