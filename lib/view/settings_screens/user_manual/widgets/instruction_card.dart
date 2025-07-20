import 'package:flutter/material.dart';
import '../../../../theme/app_theme_helper.dart';

Widget instructionCard(BuildContext context, String content) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppThemeHelper.cardColor(context),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(13),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Text(
      content,
      style: TextStyle(
        fontSize: 14.5,
        height: 1.5,
        color: AppThemeHelper.textColor(context).withAlpha((0.85 * 255).toInt()),
      ),
    ),
  );
}