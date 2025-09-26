// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_template_source.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListTemplateSourceAdapter extends TypeAdapter<ListTemplateSource> {
  @override
  final int typeId = 13;

  @override
  ListTemplateSource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListTemplateSource(
      name: fields[0] as String,
      url: fields[1] as String,
      isDefault: fields[2] as bool,
      isEnabled: fields[3] as bool,
      fetchedData: (fields[4] as List?)?.cast<CloudTemplate>(),
      lastFetchDate: fields[5] as DateTime?,
      lastError: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ListTemplateSource obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.isDefault)
      ..writeByte(3)
      ..write(obj.isEnabled)
      ..writeByte(4)
      ..write(obj.fetchedData)
      ..writeByte(5)
      ..write(obj.lastFetchDate)
      ..writeByte(6)
      ..write(obj.lastError);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListTemplateSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
