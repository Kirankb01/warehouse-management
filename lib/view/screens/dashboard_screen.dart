import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/view/screens/summary_view.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';
import 'package:warehouse_management/viewmodel/summary_view_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedFilter = 'Today';
  String selectedPieFilter = 'This Week';

  // final List<String> filters = ['Today', 'This Week', 'This Month'];
  final List<String> chartFilters = [
    'This Week',
    'Last Week',
    'This Month',
    'Last 3 Month',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SummaryViewModel>(context, listen: false).loadSummaryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get the global SummaryViewModel and initialize screen size once
    final summaryVM = Provider.of<SummaryViewModel>(context);
    summaryVM.initScreenSize(screenWidth, screenHeight);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Text('Welcome KB Stores', style: AppTextStyles.appBarText),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: GestureDetector(
              child: Icon(Icons.notifications),
              onTap: () => Navigator.pushNamed(context, '/notification'),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.card, // Same as AppBar
              AppColors.background, // Your off-white background
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: 180),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.summaryContainer,
                  ),
                  child: SummaryView(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                ),
                SizedBox(height: screenHeight * 0.012),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/allItems'),
                  child: Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      final productCount = provider.products.length;
                      return Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Card(
                          color: AppColors.pureWhite,
                          child: ListTile(
                            leading: Icon(Icons.card_travel),
                            title: Text('All Items'),
                            subtitle: Text('$productCount items available'),
                            trailing: Icon(
                              Icons.arrow_forward,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.029),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Analytics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedPieFilter,
                            dropdownColor: AppColors.pureWhite,
                            iconEnabledColor: Colors.black,
                            style: TextStyle(color: Colors.black),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPieFilter = newValue!;
                              });
                            },
                            items:
                                chartFilters.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.020),
                // Card(color: Colors.white, child: buildSalesChart(data)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
