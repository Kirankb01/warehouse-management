import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';

void showDeleteSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppColors.darkRed,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 2),
    ),
  );
}




void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: AppColors.pureWhite)),
      backgroundColor: AppColors.darkGreen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    ),
  );
}



void showSnackBar(BuildContext context,String message,{Color? backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.pureWhite),
          SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: backgroundColor ?? AppColors.darkBlue,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}




// void authSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(
//         message,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       backgroundColor: backgroundColor ?? const Color(0xFF88C0D0),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       duration: const Duration(seconds: 3),
//     ),
//   );
// }

