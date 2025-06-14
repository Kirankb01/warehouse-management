import 'package:flutter/material.dart';
import 'package:warehouse_management/Screens/purchase_details_screen.dart';


class PurchaseHistoryTab extends StatelessWidget {
  final List<Map<String, dynamic>> purchaseData = [
    {
      'supplierName': 'ABC Supplies',
      'items': [  // <-- changed from 'item' to 'items'
        {
          'product': 'Printer',
          'quantity': 1,
          'price': 4500.0,
        }
      ],
      'date': DateTime.now(),
      'total': 4500.0,
    }
  ];

   PurchaseHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return purchaseData.isEmpty
        ? Center(child: Text('No purchase history available'))
        : ListView.builder(
      itemCount: purchaseData.length,
      itemBuilder: (context, index) {
        final purchase = purchaseData[index];
        final date = purchase['date'] as DateTime;
        return Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(

              leading: Icon(Icons.shopping_cart, color: Colors.blue),
              title: Text(
                purchase['supplierName'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Date: ${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}  •  Time: ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
              ),
              trailing: Text(
                '₹${purchase['total'].toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...purchase['items'].map<Widget>((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['product'], style: TextStyle(fontSize: 16)),
                              Text('Qty: ${item['quantity']}'),
                              Text('₹${(item['price'] as double).toStringAsFixed(2)}'),
                            ],
                          ),
                        );
                      }).toList(),

                      SizedBox(height: 12),

                      // 🔽 Download Invoice Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PurchaseDetailsScreen(purchase: purchase),
                              ),
                            );
                          },
                          icon: Icon(Icons.download),
                          label: Text('Download Invoice'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
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
    );
  }
}
