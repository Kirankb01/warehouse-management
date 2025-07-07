import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/models/app_settings.dart';

class OrganizationProfileViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedTimezone = 'GMT+5:30';
  String? selectedDateFormat = 'dd-MM-yyyy';
  String? selectedCountry = 'India';
  String? selectedCurrency = 'INR ₹';
  String? logoPath;

  final List<String> timezones = ['GMT+5:30', 'UTC', 'PST', 'EST'];
  final List<String> dateFormats = ['dd-MM-yyyy', 'MM-dd-yyyy', 'yyyy-MM-dd'];
  final List<String> countries = ['India', 'USA', 'UK', 'Canada'];
  final List<String> currencies = ['INR ₹', 'USD \$', 'GBP £', 'CAD \$'];

  void setSelectedTimezone(String? value) {
    selectedTimezone = value;
    notifyListeners();
  }

  void setSelectedDateFormat(String? value) {
    selectedDateFormat = value;
    notifyListeners();
  }

  void setSelectedCountry(String? value) {
    selectedCountry = value;
    notifyListeners();
  }

  void setSelectedCurrency(String? value) {
    selectedCurrency = value;
    notifyListeners();
  }

  Future<void> pickLogo() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(image.path); // keep the original filename
      final savedImagePath = path.join(appDir.path, 'logos', fileName);

      // Create 'logos' folder if not exists
      final logoDir = Directory(path.join(appDir.path, 'logos'));
      if (!await logoDir.exists()) {
        await logoDir.create(recursive: true);
      }

      // Copy the image to a permanent location
      final savedImage = await File(image.path).copy(savedImagePath);

      logoPath = savedImage.path;
      notifyListeners();
    }
  }

  Future<void> loadProfileData() async {
    final box = await Hive.openBox<AppSettings>('app_settings');
    if (box.isNotEmpty) {
      final settings = box.getAt(0);
      if (settings != null) {
        orgNameController.text = settings.organizationName;
        emailController.text = settings.email;
        phoneController.text = settings.phone;
        selectedCountry = settings.country;
        selectedCurrency = settings.currency;
        selectedTimezone = settings.timezone;
        selectedDateFormat = settings.dateFormat;
        logoPath = settings.logoPath;
        languageController.text = settings.language;
        isDarkMode = settings.isDarkMode;
        notifyListeners();
      }
    }
  }

  final TextEditingController languageController = TextEditingController();
  bool isDarkMode = false;

  void setDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();
  }

  Future<bool> saveProfile() async {
    if (formKey.currentState!.validate()) {
      final box = await Hive.openBox<AppSettings>('app_settings');
      final settings = AppSettings(
        organizationName: orgNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        country: selectedCountry ?? '',
        currency: selectedCurrency ?? '',
        timezone: selectedTimezone ?? '',
        dateFormat: selectedDateFormat ?? '',
        logoPath: logoPath,
        language: languageController.text.trim(),
        isDarkMode: isDarkMode,
      );

      if (box.isNotEmpty) {
        await box.putAt(0, settings);
      } else {
        await box.add(settings);
      }

      return true;
    }
    return false;
  }



  Widget buildDropdown(String label, String? value, List<String> items, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 7),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.softBackground,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightBorder, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1.2),
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            onChanged: onChanged,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  void disposeControllers() {
    orgNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    languageController.dispose();
  }
}
