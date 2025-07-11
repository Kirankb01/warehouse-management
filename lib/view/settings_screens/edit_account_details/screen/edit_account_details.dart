import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
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
      backgroundColor: AppThemeHelper.scaffoldBackground(context),
      appBar: AppBar(
        backgroundColor: AppThemeHelper.scaffoldBackground(context),
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Organization Profile',
          style: AppTextStyles.appBarText,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: viewModel.formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppThemeHelper.cardColor(context),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppThemeHelper.shadowColor(context),
                  blurRadius: 6,
                ),
              ],
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
                              backgroundColor: AppThemeHelper.inputFieldBackground(context),
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
                          Text(
                            'Add Logo',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppThemeHelper.textColor(context),
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
                buildCustomTextField("UPI ID", viewModel.upiController,
                    isRequired: true, type: TextInputType.emailAddress),
                viewModel.buildDropdown(context,"Time Zone", viewModel.selectedTimezone, viewModel.timezones,
                        (val) => viewModel.setSelectedTimezone(val)),
                viewModel.buildDropdown(context,"Date Format", viewModel.selectedDateFormat, viewModel.dateFormats,
                        (val) => viewModel.setSelectedDateFormat(val)),
                viewModel.buildDropdown(context,"Country", viewModel.selectedCountry, viewModel.countries,
                        (val) => viewModel.setSelectedCountry(val)),
                viewModel.buildDropdown(context,"Currency", viewModel.selectedCurrency, viewModel.currencies,
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
