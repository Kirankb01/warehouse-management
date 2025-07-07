import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 6)
class AppSettings extends HiveObject {
  @HiveField(0)
  String organizationName;

  @HiveField(1)
  String currency;

  @HiveField(2)
  String country;

  @HiveField(3)
  String language;

  @HiveField(4)
  bool isDarkMode;

  @HiveField(5)
  String email;

  @HiveField(6)
  String phone;

  @HiveField(7)
  String timezone;

  @HiveField(8)
  String dateFormat;

  @HiveField(9)
  String? logoPath;

  AppSettings({
    required this.organizationName,
    required this.currency,
    required this.country,
    required this.email,
    required this.phone,
    required this.timezone,
    required this.dateFormat,
    this.language = 'English',
    this.isDarkMode = false,
    this.logoPath,
  });
}

