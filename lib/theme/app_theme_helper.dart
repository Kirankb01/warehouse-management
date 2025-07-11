import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';

class AppThemeHelper {
  static Brightness brightness(BuildContext context) =>
      Theme.of(context).brightness;

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color scaffoldBackground(BuildContext context) =>
      isDark(context) ? Colors.black : AppColors.background;

  static Color appBarBackground(BuildContext context) =>
      isDark(context) ? Colors.grey[900]! : AppColors.background;

  static Color dashBoardBackground(BuildContext context) =>
      isDark(context) ? Colors.black : AppColors.background;

  static Color dashAppBarBackground(BuildContext context) =>
      isDark(context) ? Colors.black : AppColors.pureWhite;

  static Color settingBackground(BuildContext context) =>
      isDark(context) ? Colors.black : AppColors.softWhiteBlue;

  static Color cardColor(BuildContext context) =>
      isDark(context) ? Colors.grey[850]! : AppColors.card;

  static Color textColor(BuildContext context) =>
      isDark(context) ? Colors.white : Colors.black;

  static Color summaryTextColor(BuildContext context) =>
      isDark(context) ? Colors.white : Colors.white;


  static Color borderColor(BuildContext context) =>
      isDark(context) ? Colors.grey : AppColors.lightBorder;

  static Color inputFieldBackground(BuildContext context) =>
      isDark(context) ? Colors.grey[800]! : AppColors.pureWhite;

  static Color popupMenuIconColor(BuildContext context) =>
      isDark(context) ? Colors.white70 : AppColors.popupMenuIconColor;

  static Color navBarUnselected(BuildContext context) =>
      isDark(context) ? Colors.white38 : AppColors.navBarUnselected;

  static Color summaryContainer(BuildContext context) =>
      isDark(context) ? Colors.grey.shade700 : AppColors.summaryContainer;

  static Color iconColor(BuildContext context) =>
      isDark(context) ? Colors.white70 : Colors.black87;

  static Color elevatedButtonBackground(BuildContext context) =>
      isDark(context) ? Colors.deepPurple.shade700 : AppColors.themeDataColor;

  static Color dialogBackground(BuildContext context) =>
      isDark(context) ? Colors.grey[900]! : Colors.white;

  static Color hintTextColor(BuildContext context) =>
      isDark(context) ? Colors.white60 : Colors.grey;

  static Color errorTextColor(BuildContext context) =>
      isDark(context) ? Colors.red.shade300 : Colors.red;

  static Color dividerColor(BuildContext context) =>
      isDark(context) ? Colors.grey[700]! : Colors.grey[300]!;

  static Color shadowColor(BuildContext context) =>
      isDark(context) ? Colors.black45 : const Color.fromRGBO(158, 158, 158, 0.2);

  static Color inputFieldColor(BuildContext context) =>
      isDark(context) ? Colors.grey[850]! : Colors.white;

  static Color primaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;


}
