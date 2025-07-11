import 'package:flutter/material.dart';
import 'package:warehouse_management/view/sales_purchase_history_screen/widgets/purchase_history.dart';
import 'package:warehouse_management/view/sales_purchase_history_screen/widgets/sales_history.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppThemeHelper.scaffoldBackground(context),
        appBar: AppBar(
          backgroundColor: AppThemeHelper.scaffoldBackground(context),
          title: Text(
            'History',
            style: TextStyle(color: AppThemeHelper.textColor(context), fontWeight: FontWeight.bold),
          ),

          bottom: TabBar(
            indicatorColor: AppThemeHelper.textColor(context),
            labelColor: AppThemeHelper.textColor(context),
            unselectedLabelColor: AppThemeHelper.textColor(context).withAlpha(127),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            indicator: UnderlineTabIndicator(
              insets: EdgeInsets.symmetric(horizontal: 110),
            ),
            tabs: [
              Tab(child: Text('Sales', style: TextStyle(fontSize: 16))),
              Tab(child: Text('Purchase', style: TextStyle(fontSize: 16))),
            ],
          ),
        ),
        body: TabBarView(children: [SalesHistoryTab(), PurchaseHistoryTab()]),
      ),
    );
  }
}
