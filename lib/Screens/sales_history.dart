import 'package:flutter/material.dart';
import 'package:warehouse_management/Screens/sale_details_screen.dart';


class SalesHistoryTab extends StatelessWidget {
  final List<Map<String, dynamic>> salesData = [
    {
      'customerName': 'Arjun R',
      'items': [
        {'product': 'Mouse', 'quantity': 1, 'price': 600.0},
        {'product': 'Keyboard', 'quantity': 2, 'price': 750.0},
      ],
      'date': DateTime(2025, 6, 6, 15, 30),
      'total': 2100.0,
    },
    {
      'customerName': 'Kiran KB',
      'items': [
        {'product': 'Monitor', 'quantity': 1, 'price': 9000.0},
      ],
      'date': DateTime(2025, 6, 5, 10, 0),
      'total': 9000.0,
    },
  ];

  SalesHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return salesData.isEmpty
        ? Center(child: Text('No sales history available'))
        : ListView.builder(
          itemCount: salesData.length,
          itemBuilder: (context, index) {
            final sale = salesData[index];
            final date = sale['date'] as DateTime;
            return Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Icon(Icons.point_of_sale, color: Colors.green),
                  title: Text(
                    sale['customerName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: ${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}  •  Time: ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: Text(
                    '₹${sale['total'].toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...sale['items'].map<Widget>((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['product'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text('Qty: ${item['quantity']}'),
                                  Text(
                                    '₹${(item['price'] as double).toStringAsFixed(2)}',
                                  ),
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
                                    builder:
                                        (_) => SaleDetailsScreen(sale: sale),
                                  ),
                                );
                              },
                              icon: Icon(Icons.download),
                              label: Text('Download Invoice'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
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
