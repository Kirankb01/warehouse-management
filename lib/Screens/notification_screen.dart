import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';


class NotificationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> lowStockItems = [
    {'name': 'Item A', 'stock': 2},
    {'name': 'Item B', 'stock': 4},
    {'name': 'Item C', 'stock': 1},
  ];

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Notifications', style: AppTextStyles.appBarText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            lowStockItems.isEmpty
                ? Center(child: Text('All items are in stock ✅'))
                : ListView.builder(
                  itemCount: lowStockItems.length,
                  itemBuilder: (context, index) {
                    final item = lowStockItems[index];
                    return Card(
                      color: Colors.red[50],
                      child: ListTile(
                        leading: Icon(Icons.warning, color: Colors.red),
                        title: Text(
                          item['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Only ${item['stock']} left in stock!'),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
