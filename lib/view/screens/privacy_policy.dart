import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';


class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Privacy Policy', style: AppTextStyles.appBarText),
        elevation: 1,
      ),
      backgroundColor: AppColors.background,
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
                'Effective Date: June 1, 2025\n\n'
                    'This Privacy Policy outlines how we collect, use, and protect the information stored or processed through our Warehouse Management mobile application (“the App”). By using the App, you agree to the terms outlined in this policy.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text(
                '1. Data Collection',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                '- The App collects product-related information such as item names, quantities, categories, and descriptions.\n'
                    '- All information is stored locally on the device using secure, encrypted local storage (Hive).',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text(
                '2. Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                '- The App does not collect, store, or transmit any personally identifiable information (PII).\n'
                    '- No user credentials or sensitive data are shared with external servers or third-party services.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text(
                '3. Data Usage',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                '- Collected data is used exclusively for inventory management purposes within the App.\n'
                    '- Users retain full control over their data stored within the App.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text(
                '4. Data Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                '- All data is stored securely using industry-standard local storage solutions.\n'
                    '- We take reasonable steps to protect information from loss, misuse, and unauthorized access.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text(
                '5. Third-Party Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                '- This App does not integrate or share data with any third-party services or advertising platforms.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text(
                '6. Changes to this Policy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                '- We reserve the right to update or modify this Privacy Policy at any time.\n'
                    '- Continued use of the App following any changes indicates your acceptance of the revised terms.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 24),
              Text(
                '7. Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions or concerns regarding this Privacy Policy, '
                    'please contact us at:\n\n'
                    '📧 support@warehouseapp.com',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
