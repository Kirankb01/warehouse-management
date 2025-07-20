import 'package:hive/hive.dart';
part 'brand.g.dart';

@HiveType(typeId: 2)
class Brand extends HiveObject {
  @HiveField(0)
  String name;

  Brand({required this.name});
}
