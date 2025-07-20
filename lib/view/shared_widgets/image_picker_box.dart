import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';

class ImagePickerBox extends StatelessWidget {
  final String? imagePath;
  final Uint8List? imageBytes;
  final VoidCallback onTap;

  const ImagePickerBox({
    super.key,
    this.imagePath,
    this.imageBytes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double boxSize = constraints.maxWidth < 400
                ? constraints.maxWidth * 0.5
                : 160;

            Widget imageWidget;

            if (kIsWeb && imageBytes != null) {
              imageWidget = Image.memory(
                imageBytes!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            } else if (!kIsWeb && imagePath != null) {
              imageWidget = Image.file(
                io.File(imagePath!),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            } else {
              imageWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_rounded,
                    size: 32,
                    color: AppThemeHelper.iconColor(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload Image',
                    style: TextStyle(
                      color: AppThemeHelper.iconColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }

            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: boxSize,
                  width: boxSize,
                  decoration: BoxDecoration(
                    color: AppThemeHelper.inputFieldBackground(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppThemeHelper.borderColor(context)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.05 * 255).toInt()),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageWidget,
                  ),
                ),
                if ((kIsWeb && imageBytes != null) || (!kIsWeb && imagePath != null))
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.semiTransparentBlack,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
