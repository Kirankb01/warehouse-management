import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/purchase.dart';
import 'package:warehouse_management/utils/helpers.dart';

class PurchaseDetailsScreen extends StatelessWidget {
  final Purchase purchase;

  const PurchaseDetailsScreen({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text("Purchase Invoice - ${purchase.supplierName}", style: AppTextStyles.appBarText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Supplier: ${purchase.supplierName}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Text("Date: ${formatDate(purchase.dateTime)}"),
            Text("Time: ${formatTime(purchase.dateTime)}"),
            const Divider(height: 30, thickness: 1),
            const Text("Item Purchased:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Header row
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 3, child: Text("Product", style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text("Qty", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text("Price", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    const Divider(),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 3, child: Text(purchase.productName)),
                          Expanded(flex: 1, child: Text('${purchase.quantity}', textAlign: TextAlign.center)),
                          Expanded(flex: 2, child: Text('₹${purchase.price.toStringAsFixed(2)}', textAlign: TextAlign.right)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('₹${purchase.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => generateAndSharePurchaseInvoice(purchase),
                  icon: const Icon(Icons.share, color: AppColors.pureWhite),
                  label: const Text("Share PDF", style: TextStyle(color: AppColors.pureWhite)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
