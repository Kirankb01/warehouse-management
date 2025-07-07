import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/route_constants.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/view/settings_screens/settings_screen/widgets/rating_dialog.dart';
import 'package:warehouse_management/view/settings_screens/settings_screen/widgets/setting_tile.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final size = media.size;


    return Scaffold(
      backgroundColor: AppColors.softWhiteBlue,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.02,
        ),
        child: Column(
          children: [
            SettingsTile(
              title: 'Account Details',
              icon: Icons.account_circle_rounded,
              onTap: () => Navigator.pushNamed(context, RouteNames.accountDetails),
            ),
            SettingsTile(
              title: 'User Manual',
              icon: Icons.menu_book,
              onTap: () => Navigator.pushNamed(context, RouteNames.userManual),
            ),
            SettingsTile(
              title: 'Privacy Policy',
              icon: Icons.privacy_tip,
              onTap: () => Navigator.pushNamed(context, RouteNames.privacyPolicy)
              ,
            ),
            SettingsTile(
              title: 'Export App Data',
              icon: Icons.upload_file,
              onTap: () => showCustomDialog(
                context: context,
                title: "Export App Data",
                content: "Do you want to export your data to device storage?",
                actionText: "EXPORT",
                onActionPressed: () {
                  print("Data exported");
                  Navigator.pop(context);
                },
              ),
            ),
            SettingsTile(
              title: 'Reset App Data',
              icon: Icons.restore,
              onTap: () => showCustomDialog(
                context: context,
                title: "Reset App Data",
                content: "Do you wish to delete the offline data?",
                actionText: "RESET",
                onActionPressed: () {
                  print("Data reset");
                  Navigator.pop(context);
                },
              ),
            ),
            SettingsTile(
              title: 'Dark Mode',
              icon: Icons.dark_mode,
              onTap: () {},
              trailing: Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() => isDarkMode = value);
                  },
                  activeColor: Colors.deepPurpleAccent,
                  activeTrackColor: Colors.deepPurple.shade100,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade800,
                ),
              ),
            ),
            SettingsTile(
              title: 'Rate App',
              icon: Icons.star_rate,
              onTap: () => showDialog(
                context: context,
                builder: (ctx) => RatingDialog(
                  onRated: (rating) => print('User rated: $rating'),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            SizedBox(
              width: size.width * 0.4,
              height: size.height * 0.06,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout,color: AppColors.pureWhite,),
                label: Text(
                  'Logout',
                  style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () => showCustomDialog(
                  context: context,
                  title: 'Confirm Logout',
                  content: 'Are you sure you want to Logout?',
                  actionText: 'Logout',
                  onActionPressed: () async {
                    final box = Hive.box('authBox');
                    box.put('isLoggedIn', false);

                    await precacheImage(const AssetImage('assets/Taking notes-cuate.png'), context);

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteNames.login,
                          (route) => false,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
