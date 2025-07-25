import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';

class MonthlySalesChart extends StatelessWidget {
  final Map<String, double> monthlySales;
  final String title;

  const MonthlySalesChart({
    super.key,
    required this.monthlySales,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final sortedEntries =
        monthlySales.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    final labels = sortedEntries.map((e) => e.key.split('-')[1]).toList();
    final values = sortedEntries.map((e) => e.value).toList();

    final maxY =
        (values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b)) * 1.2;
    final horizontalInterval = maxY == 0 ? 1.0 : maxY / 5;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppThemeHelper.dialogBackground(context),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppThemeHelper.textColor(context),
              ),
            ),
            const SizedBox(height: 30),
            if (values.isEmpty)
              SizedBox(
                height: 220,
                child: Center(
                  child: Text(
                    "No data to display",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppThemeHelper.textColor(context).withAlpha(153),
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 220,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: Transform.scale(scale: opacity, child: child),
                    );
                  },
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: maxY,
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(
                            color: AppThemeHelper.textColor(
                              context,
                            ).withAlpha(77),
                          ),
                          bottom: BorderSide(
                            color: AppThemeHelper.textColor(
                              context,
                            ).withAlpha(77),
                          ),
                          top: BorderSide.none,
                          right: BorderSide.none,
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: horizontalInterval,
                        getDrawingHorizontalLine:
                            (val) => FlLine(
                              color: AppThemeHelper.textColor(
                                context,
                              ).withAlpha(25),
                              strokeWidth: 1,
                            ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: horizontalInterval,
                            getTitlesWidget:
                                (val, _) => Text(
                                  val >= 1000
                                      ? '${(val / 1000).toStringAsFixed(0)}K'
                                      : val.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppThemeHelper.textColor(
                                      context,
                                    ).withAlpha(153),
                                  ),
                                ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (val, meta) {
                              final index = val.toInt();
                              if (index >= 0 && index < labels.length) {
                                return Text(
                                  labels[index],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: AppThemeHelper.textColor(context),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            values.length,
                            (i) => FlSpot(i.toDouble(), values[i]),
                          ),
                          isCurved: true,
                          color: Colors.blueAccent,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(3, 169, 244, 0.2),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
