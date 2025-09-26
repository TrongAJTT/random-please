// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 12;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      fetchTimeoutSeconds: fields[0] as int,
      featureStateSavingEnabled: fields[1] as bool,
      logRetentionDays: fields[2] as int,
      fetchRetryTimes: fields[3] as int,
      focusModeEnabled: fields[4] as bool,
      saveRandomToolsState: fields[5] as bool,
      compactTabLayout: fields[6] as bool,
      remoteListTemplateCustomSource: (fields[7] as List).cast<String>(),
      remoteListTemplateDefaultState: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.fetchTimeoutSeconds)
      ..writeByte(1)
      ..write(obj.featureStateSavingEnabled)
      ..writeByte(2)
      ..write(obj.logRetentionDays)
      ..writeByte(3)
      ..write(obj.fetchRetryTimes)
      ..writeByte(4)
      ..write(obj.focusModeEnabled)
      ..writeByte(5)
      ..write(obj.saveRandomToolsState)
      ..writeByte(6)
      ..write(obj.compactTabLayout)
      ..writeByte(7)
      ..write(obj.remoteListTemplateCustomSource)
      ..writeByte(8)
      ..write(obj.remoteListTemplateDefaultState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
