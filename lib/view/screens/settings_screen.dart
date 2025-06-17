import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:warehouse_management/Screens/login_screen.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/utils/helpers.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Settings', style: AppTextStyles.appBarText),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // if inside a scroll view
                children: [
                  ListTile(
                    title: Text('Account Details'),
                    leading: Icon(Icons.account_circle_rounded),
                    onTap: () => Navigator.pushNamed(context, '/account_details'),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('User Manual'),
                    leading: Icon(Icons.man),
                    onTap: () => Navigator.pushNamed(context, '/user_manual'),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Privacy Policy'),
                    leading: Icon(Icons.privacy_tip),
                    onTap: () {
                      Navigator.pushNamed(context, '/privacy_policy');
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Reset App Data'),
                    leading: Icon(Icons.format_color_reset_sharp),
                    onTap: () {
                      showCustomDialog(
                        context: context,
                        title: "Reset App Data",
                        content:
                            "Do you wish to delete the offline data in the mobile app?",
                        actionText: "RESET",
                        onActionPressed: () {
                          print("Data resetted");
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Dark Mode'),
                    leading: Icon(Icons.dark_mode),
                    trailing: Transform.scale(
                      scale: 0.6,
                      child: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        activeColor: AppColors.primary, // The circle color when "on"
                        activeTrackColor:
                        AppColors.darkModeButtonColor, // The background track color
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      showRatingDialog(context);
                    },

                    title: Text('Rate App'),
                    leading: Icon(Icons.star_rate),
                  ),
                  Divider(),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: size.width * 0.32, // 60% of screen width
              height: size.height * 0.06,
              child: ElevatedButton(
                onPressed: () {
                  showCustomDialog(
                    context: context,
                    title: "Confirm Logout",
                    content: "Are you sure you want to logout?",
                    actionText: "LOGOUT",
                    onActionPressed: () {
                      print("User logged out");
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (ctx) => LoginScreen()),
                        (route) => false,
                      );
                    },
                  );
                },

                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  // since outer container has shadow
                  backgroundColor: AppColors.alertColor,
                  shadowColor: AppColors.pureBlack,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.power_settings_new, color: AppColors.pureWhite),
                    SizedBox(width: 8),
                    GestureDetector(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        showCustomDialog(
                          context: context,
                          title: 'Confirm Logout',
                          content: 'Are you sure you want to Logout?',
                          actionText: 'Logout',
                          onActionPressed: () async {
                            final box = Hive.box('authBox');
                            await box.put('isLoggedIn', false);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showRatingDialog(BuildContext context) {
    int selectedRating = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.pureWhite,
              title: Text('Rate StockHub'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("How would you rate your experience?"),
                  SizedBox(height: 12),
                  // Single line of stars with horizontal scroll safety
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColors.ratingColor,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    print('User rated: $selectedRating');
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
