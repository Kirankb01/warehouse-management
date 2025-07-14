import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:warehouse_management/models/purchase.dart';
import 'package:warehouse_management/models/sale.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';

Future<void> generateAndShareInvoice(Sale sale) async {
  final pdf = pw.Document();

  final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
  final customFont = pw.Font.ttf(fontData.buffer.asByteData());

  pdf.addPage(
    pw.Page(
      build:
          (pw.Context context) => pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.DefaultTextStyle(
              style: pw.TextStyle(font: customFont),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "SALE INVOICE",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  pw.Text("Customer: ${sale.customerName}"),
                  pw.Text("Date: ${formatDate(sale.saleDateTime)}"),
                  pw.Text("Time: ${formatTime(sale.saleDateTime)}"),
                  pw.Divider(),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "Items Purchased:",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  buildInvoiceTable(sale.items, customFont),
                  pw.Spacer(),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "Total:",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "₹${sale.total.toStringAsFixed(2)}",
                        style: pw.TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    ),
  );

  final bytes = await pdf.save();

  if (kIsWeb) {
    await Printing.layoutPdf(onLayout: (format) async => bytes);
  } else {
    final dir = await getTemporaryDirectory();
    final file = io.File("${dir.path}/invoice_${sale.customerName}.pdf");
    await file.writeAsBytes(bytes);

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'invoice_${sale.customerName}.pdf',
    );
  }
}

// This is for purchase

Future<void> generateAndSharePurchaseInvoice(Purchase purchase) async {
  final pdf = pw.Document();

  final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
  final customFont = pw.Font.ttf(fontData.buffer.asByteData());

  pdf.addPage(
    pw.Page(
      build:
          (pw.Context context) => pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.DefaultTextStyle(
              style: pw.TextStyle(font: customFont),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "PURCHASE INVOICE",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  pw.Text("Supplier: ${purchase.supplierName}"),
                  pw.Text("Date: ${formatDate(purchase.dateTime)}"),
                  pw.Text("Time: ${formatTime(purchase.dateTime)}"),
                  pw.Divider(),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    "Item Purchased:",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  buildPurchaseInvoiceTable(purchase, customFont),
                  pw.Spacer(),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "Total:",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "₹${purchase.total.toStringAsFixed(2)}",
                        style: pw.TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    ),
  );

  final pdfBytes = await pdf.save();

  if (kIsWeb) {
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  } else {
    final dir = await getTemporaryDirectory();
    final file = io.File(
      "${dir.path}/purchase_invoice_${purchase.supplierName}.pdf",
    );
    await file.writeAsBytes(pdfBytes);

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'purchase_invoice_${purchase.supplierName}.pdf',
    );
  }
}
