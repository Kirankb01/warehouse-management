import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/viewmodel/organization_profile_view_model.dart';

class OrganizationDetailsCard extends StatelessWidget {
  final OrganizationProfileViewModel viewModel;

  const OrganizationDetailsCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              // Left Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: const [Icon(Icons.language), SizedBox(width: 8), Text('Country')]),
                  const SizedBox(height: 8),
                  Text(viewModel.selectedCountry ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Row(children: const [Icon(Icons.access_time_filled_outlined), SizedBox(width: 8), Text('Time Zone')]),
                  const SizedBox(height: 8),
                  Text(viewModel.selectedTimezone ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 75),

              // Right Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: const [Icon(Icons.monetization_on), SizedBox(width: 8), Text('Currency')]),
                  const SizedBox(height: 8),
                  Text(viewModel.selectedCurrency ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Row(children: const [Icon(Icons.date_range), SizedBox(width: 8), Text('Date Format')]),
                  const SizedBox(height: 8),
                  Text(viewModel.selectedDateFormat ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
