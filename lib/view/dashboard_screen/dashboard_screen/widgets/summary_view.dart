import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/viewmodel/summary_view_model.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_text_styles.dart';

class SummaryView extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const SummaryView({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SummaryViewModel>(
      builder: (context, summary, _) {
        return Padding(
          padding: const EdgeInsets.all(10),
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
                  Text(
                    '${summary.soldQty}',
                    style: AppTextStyles.dashBoardText,
                  ),
                  SizedBox(height: screenHeight * 0.012),
                  Text(
                    'Earnings [INR]',
                    style: TextStyle(color: AppColors.pureWhite),
                  ),
                  SizedBox(height: screenHeight * 0.006),
                  Text(
                    '₹${summary.earnings.toStringAsFixed(2)}',
                    style: AppTextStyles.dashBoardText,
                  ),
                ],
              ),
              const Spacer(),
              // Right Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.03),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.filter_alt_outlined,
                          color: AppColors.pureWhite,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: summary.selectedFilter,
                            dropdownColor: Colors.blueGrey,
                            iconEnabledColor: AppColors.pureWhite,
                            style: const TextStyle(
                              color: AppColors.pureWhite,
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                summary.setFilter(newValue);
                              }
                            },
                            items:
                                ['Today', 'This Week', 'This Month'].map(
                                  (value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
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
                  Text(
                    '${summary.purchasedQty}',
                    style: AppTextStyles.dashBoardText,
                  ),
                  SizedBox(height: screenHeight * 0.012),
                  Text(
                    "Spending's [INR]",
                    style: TextStyle(color: AppColors.pureWhite),
                  ),
                  SizedBox(height: screenHeight * 0.006),
                  Text(
                    '₹${summary.spendings.toStringAsFixed(2)}',
                    style: AppTextStyles.dashBoardText,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
