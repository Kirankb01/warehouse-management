import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/view/settings_screens/account_details/widgets/organization_detail_card.dart';
import 'package:warehouse_management/viewmodel/organization_profile_view_model.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OrganizationProfileViewModel>(context, listen: false).loadProfileData());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrganizationProfileViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: AppThemeHelper.scaffoldBackground(context),
          appBar: AppBar(
            backgroundColor: AppThemeHelper.scaffoldBackground(context),
            title: Text('Organization Profile', style: AppTextStyles.appBarText),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: GestureDetector(
                  child: const Icon(Icons.edit),
                  onTap: () async {
                    await Navigator.pushNamed(context, '/edit_account_details');
                    viewModel.loadProfileData();
                  },
                ),
              ),
            ],
          ),
          body: viewModel.orgNameController.text.trim().isEmpty
              ? const Center(child: Text('No profile found'))
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Profile Header
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 8, left: 8, bottom: 8),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppThemeHelper.cardColor(context),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 35),
                              Text(
                                viewModel.orgNameController.text,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              const SizedBox(height: 5),
                              Text(viewModel.emailController.text),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -30,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: AppThemeHelper.cardColor(context),
                            backgroundImage: viewModel.getLogoImageProvider(),
                            child: viewModel.logoPath == null
                                ? const Icon(Icons.other_houses_outlined)
                                : null,
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  OrganizationDetailsCard(viewModel: viewModel),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}



