import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/utils/helpers/snackBar_helpers.dart';
import 'package:warehouse_management/view/shared_widgets/custom_text_field.dart';
import 'package:warehouse_management/viewmodel/organization_profile_view_model.dart';


class OrganizationProfileScreen extends StatelessWidget {
  const OrganizationProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrganizationProfileViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Organization Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: viewModel.formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: viewModel.pickLogo,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: viewModel.logoPath != null
                                  ? FileImage(File(viewModel.logoPath!))
                                  : null,
                              child: viewModel.logoPath == null
                                  ? const Icon(Icons.camera_alt_outlined, size: 30, color: Colors.grey)
                                  : null,
                            ),
                            if (viewModel.logoPath != null)
                              const Positioned(
                                bottom: 4,
                                right: 4,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.edit, size: 14, color: Colors.black),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (viewModel.logoPath == null)
                          const Text(
                            'Add Logo',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                buildCustomTextField("Organization Name", viewModel.orgNameController,
                    isRequired: true, capitalization: TextCapitalization.words),
                buildCustomTextField("Registered Email", viewModel.emailController,
                    isRequired: true, type: TextInputType.emailAddress),
                buildCustomTextField("Phone Number", viewModel.phoneController,
                    isRequired: true, type: TextInputType.phone),
                viewModel.buildDropdown("Time Zone", viewModel.selectedTimezone, viewModel.timezones,
                        (val) => viewModel.setSelectedTimezone(val)),
                viewModel.buildDropdown("Date Format", viewModel.selectedDateFormat, viewModel.dateFormats,
                        (val) => viewModel.setSelectedDateFormat(val)),
                viewModel.buildDropdown("Country", viewModel.selectedCountry, viewModel.countries,
                        (val) => viewModel.setSelectedCountry(val)),
                viewModel.buildDropdown("Currency", viewModel.selectedCurrency, viewModel.currencies,
                        (val) => viewModel.setSelectedCurrency(val)),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await viewModel.saveProfile();
                        if (success && context.mounted) {
                          showSuccessSnackBar(context,'Profile saved');
                          Navigator.pop(context);
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Save Profile',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
