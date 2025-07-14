import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';

class NoUpiFoundWidget extends StatelessWidget {
  final VoidCallback onCompleteProfile;

  const NoUpiFoundWidget({super.key, required this.onCompleteProfile});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: AppThemeHelper.iconColor(context),
            ),
            const SizedBox(height: 24),
            Text(
              'Online Payment Unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppThemeHelper.textColor(context),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No UPI ID was found for this organization. '
              'Please complete your Organization Profile to enable UPI payments.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppThemeHelper.hintTextColor(context),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onCompleteProfile,
              icon: Icon(Icons.settings, color: AppColors.pureWhite),
              label: Text(
                'Complete Profile',
                style: TextStyle(fontSize: 16, color: AppColors.pureWhite),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeHelper.elevatedButtonBackground(
                  context,
                ),
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
    );
  }
}
