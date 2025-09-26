// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CloudTemplateAdapter extends TypeAdapter<CloudTemplate> {
  @override
  final int typeId = 14;

  @override
  CloudTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CloudTemplate(
      name: fields[0] as String,
      lang: fields[1] as String,
      values: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CloudTemplate obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.lang)
      ..writeByte(2)
      ..write(obj.values);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloudTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
