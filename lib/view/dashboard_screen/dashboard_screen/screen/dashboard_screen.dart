import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/constants/route_constants.dart';
import 'package:warehouse_management/models/app_settings.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
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
      backgroundColor: AppThemeHelper.dashBoardBackground(context),
      appBar: AppBar(
        backgroundColor: AppThemeHelper.dashAppBarBackground(context),
        title: Text(
          'Welcome $orgName',
          style: AppTextStyles.appBarText.copyWith(
            color: AppThemeHelper.textColor(context),
          ),
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
                  onTap:
                      () =>
                          Navigator.pushNamed(context, RouteNames.notification),
                  child: NotificationIcon(hasNotifications: hasNotifications),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient:
              Theme.of(context).brightness == Brightness.dark
                  ? null
                  : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppThemeHelper.cardColor(context),
                      AppThemeHelper.scaffoldBackground(context),
                    ],
                  ),
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? AppThemeHelper.scaffoldBackground(context)
                  : null,
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
                  color: AppThemeHelper.summaryContainer(context),
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
                        color: AppThemeHelper.cardColor(context),
                        child: ListTile(
                          leading: Icon(
                            Icons.card_travel,
                            color: AppThemeHelper.iconColor(context),
                          ),
                          title: Text(
                            'All Items',
                            style: TextStyle(
                              color: AppThemeHelper.textColor(context),
                            ),
                          ),
                          subtitle: Text(
                            '$productCount items available',
                            style: TextStyle(
                              color: AppThemeHelper.textColor(
                                context,
                              ).withAlpha((0.7 * 255).toInt()),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward,
                            color: AppThemeHelper.iconColor(context),
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
                      color: AppThemeHelper.textColor(context),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.filter_alt_outlined,
                        color: AppThemeHelper.iconColor(context),
                        size: 20,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPieFilter,
                          dropdownColor: AppThemeHelper.cardColor(context),
                          iconEnabledColor: AppThemeHelper.iconColor(context),
                          style: TextStyle(
                            color: AppThemeHelper.textColor(context),
                          ),
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
