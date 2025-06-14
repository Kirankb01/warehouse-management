
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/salesdata.dart';


/// Reusable chart function
Widget buildSalesChart(List<SalesData> data, {String title = 'Monthly Sales Report'}) {
  return SfCartesianChart(
    title: ChartTitle(text: title),
    primaryXAxis: CategoryAxis(),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: <CartesianSeries<SalesData, String>>[
      LineSeries<SalesData, String>(
        dataSource: data,
        xValueMapper: (SalesData sales, _) => sales.month,
        yValueMapper: (SalesData sales, _) => sales.sales,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ),
    ],
  );
}



