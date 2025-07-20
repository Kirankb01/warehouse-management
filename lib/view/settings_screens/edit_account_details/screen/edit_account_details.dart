import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
        title: Text('Organization Profile', style: AppTextStyles.appBarText),
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
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(13),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    AppThemeHelper.inputFieldBackground(
                                      context,
                                    ),
                                backgroundImage:
                                    kIsWeb
                                        ? (viewModel.logoPath != null
                                            ? MemoryImage(
                                              base64Decode(viewModel.logoPath!),
                                            )
                                            : null)
                                        : (viewModel.logoPath != null &&
                                                File(
                                                  viewModel.logoPath!,
                                                ).existsSync()
                                            ? FileImage(
                                              File(viewModel.logoPath!),
                                            )
                                            : null),
                                child:
                                    viewModel.logoPath == null
                                        ? const Icon(
                                          Icons.camera_alt_outlined,
                                          size: 30,
                                          color: Colors.grey,
                                        )
                                        : null,
                              ),
                            ),
                            if (viewModel.logoPath != null)
                              const Positioned(
                                bottom: 4,
                                right: 4,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: Colors.black,
                                  ),
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
                buildCustomTextField(
                  "Organization Name",
                  viewModel.orgNameController,
                  isRequired: true,
                  capitalization: TextCapitalization.words,
                ),
                buildCustomTextField(
                  "Registered Email",
                  viewModel.emailController,
                  isRequired: true,
                  type: TextInputType.emailAddress,
                ),
                buildCustomTextField(
                  "Phone Number",
                  viewModel.phoneController,
                  isRequired: true,
                  type: TextInputType.phone,
                ),
                buildCustomTextField(
                  "UPI ID",
                  viewModel.upiController,
                  isRequired: true,
                  type: TextInputType.emailAddress,
                ),
                viewModel.buildDropdown(
                  context,
                  "Time Zone",
                  viewModel.selectedTimezone,
                  viewModel.timezones,
                  (val) => viewModel.setSelectedTimezone(val),
                ),
                viewModel.buildDropdown(
                  context,
                  "Date Format",
                  viewModel.selectedDateFormat,
                  viewModel.dateFormats,
                  (val) => viewModel.setSelectedDateFormat(val),
                ),
                viewModel.buildDropdown(
                  context,
                  "Country",
                  viewModel.selectedCountry,
                  viewModel.countries,
                  (val) => viewModel.setSelectedCountry(val),
                ),
                viewModel.buildDropdown(
                  context,
                  "Currency",
                  viewModel.selectedCurrency,
                  viewModel.currencies,
                  (val) => viewModel.setSelectedCurrency(val),
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await viewModel.saveProfile();
                        if (success && context.mounted) {
                          showSuccessSnackBar(context, 'Profile saved');
                          Navigator.pop(context);
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
