// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      supplierName: fields[0] as String,
      itemName: fields[1] as String,
      sku: fields[2] as String,
      brand: fields[3] as String,
      openingStock: fields[4] as int,
      reorderPoint: fields[5] as int,
      sellingPrice: fields[6] as double,
      costPrice: fields[7] as double,
      imagePath: fields[8] as String?,
      description: fields[9] as String?,
      imageBytes: fields[10] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.supplierName)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.sku)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.openingStock)
      ..writeByte(5)
      ..write(obj.reorderPoint)
      ..writeByte(6)
      ..write(obj.sellingPrice)
      ..writeByte(7)
      ..write(obj.costPrice)
      ..writeByte(8)
      ..write(obj.imagePath)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.imageBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
