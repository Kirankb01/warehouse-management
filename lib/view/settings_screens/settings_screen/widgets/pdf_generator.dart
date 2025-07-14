import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/models/sale.dart';
import 'package:warehouse_management/models/purchase.dart';

Future<Future<Uint8List>> generateFullAppReportPDF() async {
  final pdf = pw.Document();

  final productBox = Hive.box<Product>('productsBox');
  final salesBox = Hive.box<Sale>('salesBox');
  final purchaseBox = Hive.box<Purchase>('purchases');

  final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  final dateFormat = DateFormat('dd MMM yyyy – hh:mm a');

  final regularFont = await PdfGoogleFonts.robotoRegular();
  final boldFont = await PdfGoogleFonts.robotoBold();

  final titleStyle = pw.TextStyle(
    fontSize: 18,
    fontWeight: pw.FontWeight.bold,
    font: boldFont,
  );

  pw.ImageProvider? logo;
  try {
    final logoBytes = await rootBundle.load('assets/login_img.png');
    logo = pw.MemoryImage(logoBytes.buffer.asUint8List());
  } catch (_) {}

  pdf.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
      build:
          (context) => [
            if (logo != null) pw.Center(child: pw.Image(logo, height: 60)),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                'TrackIn Full Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Divider(),

            pw.Text('Product Inventory', style: titleStyle),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.5),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(1.5),
                4: const pw.FlexColumnWidth(1),
                5: const pw.FlexColumnWidth(1.5),
                6: const pw.FlexColumnWidth(1.5),
                7: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    for (final h in [
                      'SKU',
                      'Item Name',
                      'Brand',
                      'Supplier',
                      'Stock',
                      'Reorder Point',
                      'Selling Price',
                      'Cost Price',
                    ])
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          h,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                ...productBox.values.map((p) {
                  return pw.TableRow(
                    children: [
                      _cell(p.sku),
                      _cell(p.itemName),
                      _cell(p.brand),
                      _cell(p.supplierName),
                      _cell(p.openingStock.toString()),
                      _cell(p.reorderPoint.toString()),
                      _cell(currencyFormat.format(p.sellingPrice)),
                      _cell(currencyFormat.format(p.costPrice)),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 24),

            pw.Text('Sales History', style: titleStyle),
            pw.SizedBox(height: 8),
            ..._groupSalesByDate(salesBox.values.toList()).entries.map((entry) {
              final sales = entry.value;

              final rows = <List<String>>[];
              for (var sale in sales) {
                for (var item in sale.items) {
                  rows.add([
                    sale.customerName,
                    item.sku ?? '-',
                    item.productName,
                    item.quantity.toString(),
                    currencyFormat.format(item.price),
                    currencyFormat.format(item.price * item.quantity),
                    dateFormat.format(sale.saleDateTime),
                  ]);
                }
              }

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Date: ${dateFormat.format(sales.first.saleDateTime)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  _customTable(
                    headers: [
                      'Customer',
                      'SKU',
                      'Product',
                      'Qty',
                      'Price',
                      'Total',
                      'Time',
                    ],
                    rows: rows,
                  ),
                  pw.SizedBox(height: 12),
                ],
              );
            }),

            pw.SizedBox(height: 24),
            pw.Text('Purchase History', style: titleStyle),
            pw.SizedBox(height: 8),
            _customTable(
              headers: ['Date', 'Supplier', 'Product', 'Qty', 'Price', 'Total'],
              rows:
                  purchaseBox.values.map((p) {
                    return [
                      dateFormat.format(p.dateTime),
                      p.supplierName,
                      p.productName,
                      p.quantity.toString(),
                      currencyFormat.format(p.price),
                      currencyFormat.format(p.total),
                    ];
                  }).toList(),
            ),
          ],
    ),
  );

  return pdf.save();
}

pw.Widget _cell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
  );
}

Map<String, List<Sale>> _groupSalesByDate(List<Sale> sales) {
  final Map<String, List<Sale>> grouped = {};
  for (var sale in sales) {
    final dateKey = DateFormat('yyyy-MM-dd').format(sale.saleDateTime);
    grouped.putIfAbsent(dateKey, () => []).add(sale);
  }
  return grouped;
}

pw.Widget _customTable({
  required List<String> headers,
  required List<List<String>> rows,
}) {
  return pw.Table(
    border: pw.TableBorder.all(color: PdfColors.grey),
    children: [
      pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey300),
        children:
            headers
                .map(
                  (h) => pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(
                      h,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                )
                .toList(),
      ),
      ...rows.map(
        (row) => pw.TableRow(
          children:
              row
                  .map(
                    (cell) => pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        cell,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    ],
  );
}
