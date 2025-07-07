import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/sale.dart';
import 'package:warehouse_management/utils/helpers.dart';

class SaleDetailsScreen extends StatelessWidget {
  final Sale sale;

  const SaleDetailsScreen({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text("Sale Invoice - ${sale.customerName}", style: AppTextStyles.appBarText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer: ${sale.customerName}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 6),
            Text("Date: ${formatDate(sale.saleDateTime)}"),
            Text("Time: ${formatTime(sale.saleDateTime)}"),
            Divider(height: 30, thickness: 1),
            Text("Items Purchased:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(flex: 3, child: Text("Product", style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text("Qty", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text("Price", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    const Divider(),

                    ...sale.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 3, child: Text(item.productName)),
                          Expanded(flex: 1, child: Text('${item.quantity}', textAlign: TextAlign.center)),
                          Expanded(flex: 2, child: Text('₹${item.price.toStringAsFixed(2)}', textAlign: TextAlign.right)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),

            Spacer(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('₹${sale.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => generateAndShareInvoice(sale),
                  icon: Icon(Icons.share, color: AppColors.pureWhite),
                  label: Text("Share PDF", style: TextStyle(color: AppColors.pureWhite)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.successColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
