import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/view/screens/purchase_history.dart';
import 'package:warehouse_management/view/screens/sales_history.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Match with TabBarView children count
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            'History',
            style: TextStyle(color: AppColors.pureBlack, fontWeight: FontWeight.bold),
          ),

          bottom: TabBar(
            indicatorColor: AppColors.pureWhite,
            labelColor: AppColors.pureBlack,
            unselectedLabelColor: AppColors.unselectedColor,
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
