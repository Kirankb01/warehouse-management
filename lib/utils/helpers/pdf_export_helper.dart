import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:warehouse_management/view/settings_screens/settings_screen/widgets/pdf_generator.dart';

void exportAppDataToPDF(BuildContext context) async {
  final pdfFile = await generateFullAppReportPDF();
  await Printing.sharePdf(
    bytes: await pdfFile.readAsBytes(),
    filename: 'TrackIn_Report.pdf',
  );
}
