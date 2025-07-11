import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/constants/route_constants.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/selling_screen/widgets/no_upi_found_widget.dart';
import 'package:warehouse_management/viewmodel/organization_profile_view_model.dart';

class QrPaymentScreen extends StatelessWidget {
  final double amount;
  final VoidCallback onPaid;

  const QrPaymentScreen({
    super.key,
    required this.amount,
    required this.onPaid,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrganizationProfileViewModel>(
      context,
      listen: false,
    );
    final upiLink = viewModel.generateUpiLink(context, amount);

    final textColor = AppThemeHelper.textColor(context);
    final bgColor = AppThemeHelper.scaffoldBackground(context);
    final qrBgColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : AppColors.pureWhite;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Online Payment', style: AppTextStyles.appBarText),
      ),
      body:
          upiLink.isEmpty
              ? NoUpiFoundWidget(
                onCompleteProfile: () {
                  Navigator.pushNamed(context, RouteNames.accountDetails);
                },
              )
              : SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Scan to Pay",
                            style: TextStyle(
                              color: AppColors.summaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                            ),
                          ),
                          const SizedBox(height: 16),
                          QrImageView(
                            data: upiLink,
                            version: QrVersions.auto,
                            size: 250,
                            backgroundColor: qrBgColor,
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.summaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Total: ₹${amount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.pureWhite,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "Use any UPI app to complete the payment",
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor.withAlpha((0.7 * 255).toInt()),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: () {
                              onPaid();
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.check_circle,
                              color: AppColors.pureWhite,
                            ),
                            label: const Text(
                              "Mark as Paid",
                              style: TextStyle(
                                color: AppColors.pureWhite,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.successColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
