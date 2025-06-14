import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';


class PurchaseDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> purchase;

  const PurchaseDetailsScreen({super.key, required this.purchase});

  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = pw.Document();
    final date = purchase['date'] as DateTime;

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Purchase Invoice',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Supplier: ${purchase['supplierName']}'),
              pw.Text('Date: ${date.day}-${date.month}-${date.year}'),
              pw.Text(
                'Time: ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'Items:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              ...purchase['items'].map<pw.Widget>((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${item['product']}'),
                    pw.Text('Qty: ${item['quantity']}'),
                    pw.Text('₹${(item['price'] as double).toStringAsFixed(2)}'),
                  ],
                );
              }).toList(),
              pw.Divider(),
              pw.Text(
                'Total: ₹${purchase['total'].toStringAsFixed(2)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/purchase_invoice_${date.millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Invoice saved to ${file.path}')));
  }

  @override
  Widget build(BuildContext context) {
    final date = purchase['date'] as DateTime;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Purchase Details', style: AppTextStyles.appBarText),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            tooltip: 'Download PDF',
            onPressed: () => _downloadPDF(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supplier: ${purchase['supplierName']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text('Date: ${date.day}-${date.month}-${date.year}'),
                    Text(
                      'Time: ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                    ),
                    Divider(height: 20),
                    Text(
                      'Items:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    ...purchase['items'].map<Widget>((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item['product']}'),
                            Text('Qty: ${item['quantity']}'),
                            Text(
                              '₹${(item['price'] as double).toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    Divider(height: 20),
                    Text(
                      'Total: ₹${purchase['total'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
