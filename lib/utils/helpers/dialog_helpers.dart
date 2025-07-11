import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/utils/helpers/bottomSheet_helpers.dart';
import 'package:warehouse_management/viewmodel/brand_provider.dart';
import '../../view/selling_screen/screens/selling_screen.dart';

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String actionText,
  required VoidCallback onActionPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final baseTextColor = AppThemeHelper.textColor(context);

      final textColor80 = baseTextColor.withAlpha(204);
      final textColor70 = baseTextColor.withAlpha(179);

      return AlertDialog(
        backgroundColor: AppThemeHelper.dialogBackground(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: baseTextColor,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(fontSize: 15, color: textColor80),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onActionPressed();
            },
            child: Text(
              actionText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showAddBrandDialog(BuildContext context) {
  final brandController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: AppThemeHelper.dialogBackground(context),
          title: Text(
            'Add New Brand',
            style: TextStyle(color: AppThemeHelper.textColor(context)),
          ),
          content: TextField(
            controller: brandController,
            style: TextStyle(color: AppThemeHelper.textColor(context)),
            decoration: InputDecoration(
              hintText: 'Enter brand name',
              hintStyle: TextStyle(
                color: AppThemeHelper.textColor(
                  context,
                ).withAlpha(153), // 0.6 * 255 = 153
              ),
              filled: true,
              fillColor: AppThemeHelper.inputFieldBackground(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppThemeHelper.borderColor(context),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppThemeHelper.borderColor(context),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppThemeHelper.textColor(context),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final brandName = brandController.text.trim();
                if (brandName.isNotEmpty) {
                  await Provider.of<BrandProvider>(
                    context,
                    listen: false,
                  ).addBrand(brandName);
                  Navigator.pop(context, brandName);
                }
              },
              child: Text(
                'Add',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
  );
}

void showDeleteBrandDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController searchController = TextEditingController();

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppThemeHelper.dialogBackground(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            contentPadding: const EdgeInsets.all(20),
            title: Text(
              'Delete Brand',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppThemeHelper.textColor(context),
              ),
            ),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Consumer<BrandProvider>(
                  builder: (_, provider, __) {
                    final query = searchController.text.toLowerCase();
                    final filteredBrands =
                        provider.brands
                            .where(
                              (brand) =>
                                  brand.name.toLowerCase().contains(query),
                            )
                            .toList();

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: searchController,
                          style: TextStyle(
                            color: AppThemeHelper.textColor(context),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search brand...',
                            hintStyle: TextStyle(
                              color: AppThemeHelper.textColor(
                                context,
                              ).withAlpha(153),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppThemeHelper.textColor(context),
                            ),
                            suffixIcon:
                                searchController.text.isNotEmpty
                                    ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        searchController.clear();
                                        setState(() {});
                                      },
                                    )
                                    : null,
                            filled: true,
                            fillColor: AppThemeHelper.inputFieldBackground(
                              context,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppThemeHelper.borderColor(context),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppThemeHelper.borderColor(context),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                        if (filteredBrands.isEmpty)
                          Text(
                            'No matching brands found.',
                            style: TextStyle(
                              color: AppThemeHelper.textColor(
                                context,
                              ).withAlpha(153),
                            ),
                          )
                        else
                          SizedBox(
                            height: 200,
                            width: 300,
                            child: ListView.separated(
                              itemCount: filteredBrands.length,
                              separatorBuilder:
                                  (_, __) => Divider(
                                    color: AppThemeHelper.dividerColor(context),
                                    height: 1,
                                  ),
                              itemBuilder: (context, index) {
                                final brand = filteredBrands[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  title: Text(
                                    brand.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppThemeHelper.textColor(context),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: AppColors.alertColor,
                                    ),
                                    onPressed: () async {
                                      final confirmed =
                                          await showDeleteBottomSheet(
                                            context,
                                            brand.name,
                                          );
                                      if (confirmed) {
                                        await provider.removeBrand(brand.name);
                                        setState(() {});
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: TextStyle(color: AppThemeHelper.textColor(context)),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<bool> showConfirmSaleDialog(
  BuildContext context, {
  required PaymentMethod selectedPayment,
}) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Dialog(
              backgroundColor: AppThemeHelper.dialogBackground(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      size: 50,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Confirm Sale",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThemeHelper.textColor(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Are you sure you want to submit this sale?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppThemeHelper.textColor(context).withAlpha(178),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Icon(Icons.payment_rounded, color: AppColors.primary),
                          Text(
                            selectedPayment == PaymentMethod.gpay
                                ? 'Payment Method: GPay'
                                : 'Payment Method: Cash in Hand',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppThemeHelper.textColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: AppThemeHelper.textColor(
                                  context,
                                ).withAlpha(153),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text("Submit"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.successColor,
                              foregroundColor: AppColors.pureWhite,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ) ??
      false;
}
