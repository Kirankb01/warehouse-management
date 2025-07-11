import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';


class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeHelper.scaffoldBackground(context),
      appBar: AppBar(
        title: Text('Privacy Policy', style: AppTextStyles.appBarText),
        backgroundColor: AppThemeHelper.scaffoldBackground(context),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Stock Hub',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              Text(
                'Effective Date: July 4, 2025\n\n'
                    'This Privacy Policy explains how Stock Hub ("the App") handles and protects your data. '
                    'By using this app, you agree to the practices described in this policy.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text('1. Data Collection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(
                '- The App collects basic information such as product details (name, SKU, quantity, price, etc.), '
                    'purchase/sales transactions, and optional organization profile data.\n'
                    '- No background tracking or personal data collection occurs.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text('2. Local Storage Only', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(
                '- All data is stored **locally on your device** using secure local storage (Hive).\n'
                    '- No data is uploaded to servers, cloud platforms, or shared over the internet.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text('3. Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(
                '- The App does not collect or store any sensitive personal information such as passwords, credit card details, or biometric data.\n'
                    '- Your organization name, email, phone number, and logo (if added) are stored only within your device.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text('4. No Internet Dependency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(
                '- The App is designed to work entirely offline.\n'
                    '- You are not required to sign in, connect to the internet, or sync any data externally.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text('5. Third-Party Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(
                '- Stock Hub does **not integrate** with any third-party services such as Google, Facebook, or analytics platforms.\n'
                    '- Your data is not used for advertising or shared externally in any way.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text('6. Security', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(
                '- We take reasonable precautions to secure your data within the app using encrypted local storage.\n'
                    '- You are encouraged to back up your device regularly to avoid accidental data loss.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text('7. User Control', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(
                '- You can edit or delete your app data at any time from within the app.\n'
                    '- You can export or reset all data manually using the in-app Settings options.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text('8. Updates to This Policy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(
                '- We may update this Privacy Policy in the future. Changes will be reflected within the app under the Privacy Policy section.\n'
                    '- Your continued use of the app indicates acceptance of these updates.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text('9. Contact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text(
                'If you have questions or concerns, feel free to contact us at:\n\n📧 support@stockhub.app',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

