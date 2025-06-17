import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';

// import 'package:warehouse_management/widgets/cartesian_chart.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedFilter = 'Today';
  String selectedPieFilter = 'This Week';

  final List<String> filters = ['Today', 'This Week', 'This Month'];
  final List<String> chartFilters = [
    'This Week',
    'Last Week',
    'This Month',
    'Last 3 Month',
  ];

  // final List<SalesData> data = [
  //   SalesData('Jan', 12000.0),
  //   SalesData('Feb', 15000.0),
  //   SalesData('Mar', 18000.0),
  //   SalesData('Apr', 14000.0),
  //   SalesData('May', 20000.0),
  // ];


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Welcome KB Stores', style: AppTextStyles.appBarText),
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
      body: SingleChildScrollView(
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
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.008),
                          Text('Summary', style: AppTextStyles.heading),
                          SizedBox(height: screenHeight * 0.012),
                          Text(
                            'Sold Quantities',
                            style: TextStyle(color: AppColors.pureWhite),
                          ),
                          SizedBox(height: screenHeight * 0.006),
                          Text('53', style: AppTextStyles.dashBoardText),
                          SizedBox(height: screenHeight * 0.012),
                          Text(
                            'Earnings [INR]',
                            style: TextStyle(color: AppColors.pureWhite),
                          ),
                          SizedBox(height: screenHeight * 0.006),
                          Text('25000', style: AppTextStyles.dashBoardText),
                        ],
                      ),
                      Spacer(),
                      // Right Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.03),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.filter_alt_outlined,
                                  color: AppColors.pureWhite,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedFilter,
                                    dropdownColor: Colors.blueGrey,
                                    iconEnabledColor: AppColors.pureWhite,
                                    style: TextStyle(
                                      color: AppColors.pureWhite,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedFilter = newValue!;
                                      });
                                    },
                                    items:
                                        filters.map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Purchased Quantities',
                            style: TextStyle(color: AppColors.pureWhite),
                          ),
                          SizedBox(height: screenHeight * 0.006),
                          Text('85', style: AppTextStyles.dashBoardText),
                          SizedBox(height: screenHeight * 0.012),
                          Text(
                            'Spendings [INR]',
                            style: TextStyle(color: AppColors.pureWhite),
                          ),
                          SizedBox(height: screenHeight * 0.006),
                          Text('15000', style: AppTextStyles.dashBoardText),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.012),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/allItems'),
                child: Consumer<ProductProvider>(
                  builder: (context, provider, _) {
                    final productCount = provider.products.length;
                    return Card(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  SizedBox(
                    child: Row(
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
                                chartFilters.map<DropdownMenuItem<String>>((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.020),
              // Card(color: Colors.white, child: buildSalesChart(data)),

            ],
          ),
        ),
      ),
    );
  }
}
