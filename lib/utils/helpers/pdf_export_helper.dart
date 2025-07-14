import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:warehouse_management/view/settings_screens/settings_screen/widgets/pdf_generator.dart';
import 'package:flutter/foundation.dart';

void exportAppDataToPDF(BuildContext context) async {
  final bytes = await generateFullAppReportPDF();

  if (kIsWeb) {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
    );
  } else {
    await Printing.sharePdf(
      bytes: await bytes,
      filename: 'TrackIn_Report.pdf',
    );
  }
}



