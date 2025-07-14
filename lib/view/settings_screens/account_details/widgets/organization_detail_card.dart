import 'package:flutter/material.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/viewmodel/organization_profile_view_model.dart';

class OrganizationDetailsCard extends StatelessWidget {
  final OrganizationProfileViewModel viewModel;

  const OrganizationDetailsCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppThemeHelper.cardColor(context),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildItem(
                    context,
                    Icons.language,
                    'Country',
                    viewModel.selectedCountry ?? '',
                  ),
                  const SizedBox(height: 24),
                  _buildItem(
                    context,
                    Icons.access_time_filled_outlined,
                    'Time Zone',
                    viewModel.selectedTimezone ?? '',
                  ),
                  const SizedBox(height: 24),
                  _buildItem(
                    context,
                    Icons.phone,
                    'Mobile Number',
                    viewModel.phoneController.text,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 40), // spacing between columns
            // Right Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildItem(
                    context,
                    Icons.monetization_on,
                    'Currency',
                    viewModel.selectedCurrency ?? '',
                  ),
                  const SizedBox(height: 24),
                  _buildItem(
                    context,
                    Icons.date_range,
                    'Date Format',
                    viewModel.selectedDateFormat ?? '',
                  ),
                  const SizedBox(height: 24),
                  _buildItem(
                    context,
                    Icons.qr_code,
                    'UPI ID',
                    viewModel.upiController.text,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppThemeHelper.iconColor(context), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: AppThemeHelper.textColor(context)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
