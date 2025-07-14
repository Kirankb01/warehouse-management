import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';

class ProductImageBox extends StatelessWidget {
  final String itemName;
  final String? imagePath;
  final Uint8List? imageBytes;
  final double size;
  final double borderRadius;
  final bool isCircle;
  final bool isGridView;

  const ProductImageBox({
    super.key,
    required this.itemName,
    this.imagePath,
    this.imageBytes,
    this.size = 60,
    this.borderRadius = 12,
    this.isCircle = false,
    this.isGridView = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasFileImage = !kIsWeb &&
        imagePath != null &&
        imagePath!.isNotEmpty &&
        File(imagePath!).existsSync();
    final hasMemoryImage = kIsWeb && imageBytes != null;

    final decorationImage = hasFileImage
        ? DecorationImage(image: FileImage(File(imagePath!)), fit: BoxFit.cover)
        : hasMemoryImage
        ? DecorationImage(image: MemoryImage(imageBytes!), fit: BoxFit.cover)
        : null;

    return Container(
      width: isGridView ? size * 2 : size,
      height: size,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        color: AppThemeHelper.scaffoldBackground(context),
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        image: decorationImage,
      ),
      child: (decorationImage == null)
          ? Center(
        child: Text(
          itemName.isNotEmpty ? itemName[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: size / 2.5,
            fontWeight: FontWeight.bold,
            color: AppThemeHelper.textColor(context),
          ),
        ),
      )
          : null,
    );
  }
}
