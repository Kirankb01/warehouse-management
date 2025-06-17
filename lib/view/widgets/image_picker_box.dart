import 'dart:io';
import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';

class ImagePickerBox extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const ImagePickerBox({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: size.height * 0.16,
              width: size.width * 0.35,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: imagePath == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_a_photo_rounded, size: 32, color: AppColors.onBoardScreenDot),
                  SizedBox(height: 8),
                  Text(
                    'Upload Image',
                    style: TextStyle(
                      color: AppColors.onBoardScreenDot,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            if (imagePath != null)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.edit, size: 16, color: AppColors.pureWhite),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
