import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:warehouse_management/models/purchase.dart';
import '../../models/sale.dart'; // Adjust this import as needed

pw.Table buildInvoiceTable(List<SaleItem> items, pw.Font customFont) {
  return pw.Table(
    border: pw.TableBorder.all(width: 0.5), // Optional: add light border
    columnWidths: {
      0: const pw.FlexColumnWidth(3),
      1: const pw.FlexColumnWidth(1),
      2: const pw.FlexColumnWidth(2),
    },
    children: [
      // Header
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text('Product',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: customFont,
                )),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text('Qty',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: customFont,
                ),
                textAlign: pw.TextAlign.center),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text('Price',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: customFont,
                ),
                textAlign: pw.TextAlign.right),
          ),
        ],
      ),

      // Data rows
      ...items.map(
            (e) => pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(e.productName, style: pw.TextStyle(font: customFont)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(e.quantity.toString(),
                  style: pw.TextStyle(font: customFont), textAlign: pw.TextAlign.center),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('₹${e.price.toStringAsFixed(2)}',
                  style: pw.TextStyle(font: customFont), textAlign: pw.TextAlign.right),
            ),
          ],
        ),
      ),
    ],
  );
}




//This is for purchase


pw.Table buildPurchaseInvoiceTable(Purchase purchase, pw.Font customFont) {
  return pw.Table(
    border: pw.TableBorder.all(width: 0.5),
    columnWidths: {
      0: const pw.FlexColumnWidth(3),
      1: const pw.FlexColumnWidth(1),
      2: const pw.FlexColumnWidth(2),
    },
    children: [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text('Product',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: customFont,
                )),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text('Qty',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: customFont,
                ),
                textAlign: pw.TextAlign.center),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text('Price',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: customFont,
                ),
                textAlign: pw.TextAlign.right),
          ),
        ],
      ),
      pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(purchase.productName, style: pw.TextStyle(font: customFont)),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text('${purchase.quantity}',
                style: pw.TextStyle(font: customFont), textAlign: pw.TextAlign.center),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text('₹${purchase.price.toStringAsFixed(2)}',
                style: pw.TextStyle(font: customFont), textAlign: pw.TextAlign.right),
          ),
        ],
      ),
    ],
  );
}

