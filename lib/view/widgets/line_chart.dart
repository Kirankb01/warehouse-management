import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlySalesChart extends StatelessWidget {
  final Map<String, double> monthlySales;

  const MonthlySalesChart({super.key, required this.monthlySales});

  @override
  Widget build(BuildContext context) {
    // Sort entries by date string like "2025-6"
    final sortedEntries = monthlySales.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final labels = sortedEntries.map((e) => e.key.split('-')[1]).toList();
    final values = sortedEntries.map((e) => e.value).toList();

    // Compute max Y value
    final maxY = (values.isEmpty ? 0 : values.reduce((a, b) => a > b ? a : b)) * 1.2;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sales Analytics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 220,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (context, opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: opacity,
                      child: child,
                    ),
                  );
                },
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: maxY,
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26),
                        top: BorderSide.none,
                        right: BorderSide.none,
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 5,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: maxY / 5,
                          getTitlesWidget: (val, _) => Text(
                            val >= 1000
                                ? '${(val / 1000).toStringAsFixed(0)}K'
                                : val.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
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
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
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
                              Colors.blueAccent.withOpacity(0.2),
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
