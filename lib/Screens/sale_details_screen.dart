import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';


class SaleDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> sale;

  const SaleDetailsScreen({required this.sale, super.key});

  String getFormattedDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  String getFormattedTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String buildInvoiceText() {
    final date = sale['date'] as DateTime;
    final buffer = StringBuffer();

    buffer.writeln('Customer: ${sale['customerName']}');
    buffer.writeln('----------------------------');
    buffer.writeln('Items:');
    buffer.writeln('Product      Qty   Price');

    for (var item in sale['items']) {
      String product = item['product'];
      int qty = item['quantity'];
      double price = item['price'];
      buffer.writeln(
          '${product.padRight(12)} $qty       ₹${price.toStringAsFixed(2)}');
    }

    buffer.writeln('\nDate: ${getFormattedDate(date)}');
    buffer.writeln('Time: ${getFormattedTime(date)}');
    buffer.writeln('Total: ₹${(sale['total'] as double).toStringAsFixed(2)}');

    return buffer.toString();
  }

  Future<void> saveInvoiceToFile(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/invoice_${DateTime.now().millisecondsSinceEpoch}.txt');

      final invoiceText = buildInvoiceText();
      await file.writeAsString(invoiceText);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice saved to ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save invoice: $e')),
      );
    }
  }

  void shareInvoice() {
    final invoiceText = buildInvoiceText();
    Share.share(invoiceText, subject: 'Invoice from Warehouse Management');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final date = sale['date'] as DateTime;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Invoice',style: AppTextStyles.appBarText.copyWith(
          fontSize: size.width < 600 ? 20 : 26,
        ),),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: shareInvoice,
            tooltip: 'Share Invoice',
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => saveInvoiceAsPdf(context, sale),
            tooltip: 'Download Invoice',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: ${sale['customerName']}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Divider(thickness: 2, height: 24),
                  Text('Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey[300]),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...sale['items'].map<TableRow>((item) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(item['product']),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(item['quantity'].toString()),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('₹${(item['price'] as double).toStringAsFixed(2)}'),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text('Date: ${getFormattedDate(date)}', style: TextStyle(fontSize: 16)),
                  Text('Time: ${getFormattedTime(date)}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text('Total: ₹${(sale['total'] as double).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> saveInvoiceAsPdf(BuildContext context, Map<String, dynamic> sale) async {
    final pdf = pw.Document();

    final date = sale['date'] as DateTime;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Text('Customer: ${sale['customerName']}'),
              pw.Text('Date: ${date.day}/${date.month}/${date.year}'),
              pw.Text('Time: ${date.hour}:${date.minute.toString().padLeft(2, '0')}'),
              pw.SizedBox(height: 12),
              pw.Text('Items:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ...sale['items'].map<pw.Widget>((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(item['product']),
                    pw.Text('Qty: ${item['quantity']}'),
                    pw.Text('₹${(item['price'] as double).toStringAsFixed(2)}'),
                  ],
                );
              }).toList(),
              pw.Divider(),
              pw.Text('Total: ₹${sale['total'].toStringAsFixed(2)}',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    // Get directory
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/invoice_${date.millisecondsSinceEpoch}.pdf');

    await file.writeAsBytes(await pdf.save());

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to: ${file.path}')),
    );
  }

}
