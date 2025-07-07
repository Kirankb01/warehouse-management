import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/constants/route_constants.dart';
import 'package:warehouse_management/models/app_settings.dart';
import 'package:warehouse_management/utils/helpers/dashboard_line_chart_helper.dart';
import 'package:warehouse_management/view/dashboard_screen/notification_screen/widgets/notification_icon.dart';
import 'package:warehouse_management/view/dashboard_screen/dashboard_screen/widgets/summary_view.dart';
import 'package:warehouse_management/view/shared_widgets/line_chart.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';
import 'package:warehouse_management/viewmodel/summary_view_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedPieFilter = 'Last Week';
  Map<String, double> monthlySales = {};

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
      _computeMonthlySales();
    });
  }

  void _computeMonthlySales() {
    final tempMonthly = SalesHelper.computeMonthlySales(
      selectedPieFilter,
      hiveBoxName: 'salesBox',
    );

    setState(() {
      monthlySales = tempMonthly;
    });

    print('Monthly sales map: $tempMonthly');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final summaryVM = Provider.of<SummaryViewModel>(context);
    summaryVM.initScreenSize(screenWidth, screenHeight);
    final box = Hive.box<AppSettings>('app_settings');
    final orgName = box.isNotEmpty ? box.getAt(0)?.organizationName ?? '' : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Text(
          'Welcome $orgName',
          style: AppTextStyles.appBarText,
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, _) {
                final hasNotifications = productProvider.products.any(
                  (p) => p.openingStock <= p.reorderPoint,
                );

                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RouteNames.notification),
                  child: NotificationIcon(hasNotifications: hasNotifications),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.card, AppColors.background],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(minHeight: 180),
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
                          leading: const Icon(Icons.card_travel),
                          title: const Text('All Items'),
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
                  const Text(
                    'Analytics',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.filter_alt_outlined,
                        color: AppColors.pureBlack,
                        size: 20,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPieFilter,
                          dropdownColor: AppColors.pureWhite,
                          iconEnabledColor: AppColors.pureBlack,
                          style: const TextStyle(color: AppColors.pureBlack),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPieFilter = newValue!;
                            });
                            _computeMonthlySales();
                          },
                          items:
                              chartFilters
                                  .map(
                                    (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              MonthlySalesChart(
                monthlySales: monthlySales,
                title: 'Sales Analytics',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
