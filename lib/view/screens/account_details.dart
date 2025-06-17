import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';


class AccountDetails extends StatelessWidget {
  const AccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Organization Profile', style: AppTextStyles.appBarText),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: GestureDetector(
              child: Icon(Icons.edit),
              onTap:
                  () => Navigator.pushNamed(context, '/edit_account_details'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  right: 8,
                  left: 8,
                  bottom: 8,
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    // Rectangle container
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 35),
                            child: Text(
                              'Kiran Enterprises',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('kirankb601@gmail.com'),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -30,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.pureWhite, width: 3),
                        ),
                        child: Icon(Icons.other_houses_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start, // Align everything to the start (left)
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.language),
                                SizedBox(
                                  width: 8,
                                ), // Space between icon and text
                                Text('Country'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'India',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),

                            Row(
                              children: const [
                                Icon(Icons.access_time_filled_outlined),
                                SizedBox(width: 8),
                                Text('Time Zone'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Asia/Calcutta',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(width: 75),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start, // Align everything to the start (left)
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.monetization_on),
                                SizedBox(
                                  width: 8,
                                ), // Space between icon and text
                                Text('Currency'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'INR',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),

                            Row(
                              children: const [
                                Icon(Icons.date_range),
                                SizedBox(width: 8),
                                Text('Date Format'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'dd/MM/yyyy',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
