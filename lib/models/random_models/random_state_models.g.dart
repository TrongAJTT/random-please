// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_state_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NumberGeneratorStateAdapter extends TypeAdapter<NumberGeneratorState> {
  @override
  final int typeId = 60;

  @override
  NumberGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NumberGeneratorState(
      isInteger: fields[0] as bool,
      minValue: fields[1] as double,
      maxValue: fields[2] as double,
      quantity: fields[3] as int,
      allowDuplicates: fields[4] as bool,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NumberGeneratorState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isInteger)
      ..writeByte(1)
      ..write(obj.minValue)
      ..writeByte(2)
      ..write(obj.maxValue)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.allowDuplicates)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PasswordGeneratorStateAdapter
    extends TypeAdapter<PasswordGeneratorState> {
  @override
  final int typeId = 61;

  @override
  PasswordGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PasswordGeneratorState(
      passwordLength: fields[0] as int,
      includeLowercase: fields[1] as bool,
      includeUppercase: fields[2] as bool,
      includeNumbers: fields[3] as bool,
      includeSpecial: fields[4] as bool,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PasswordGeneratorState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.passwordLength)
      ..writeByte(1)
      ..write(obj.includeLowercase)
      ..writeByte(2)
      ..write(obj.includeUppercase)
      ..writeByte(3)
      ..write(obj.includeNumbers)
      ..writeByte(4)
      ..write(obj.includeSpecial)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DateGeneratorStateAdapter extends TypeAdapter<DateGeneratorState> {
  @override
  final int typeId = 62;

  @override
  DateGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DateGeneratorState(
      startDate: fields[0] as DateTime,
      endDate: fields[1] as DateTime,
      dateCount: fields[2] as int,
      allowDuplicates: fields[3] as bool,
      lastUpdated: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DateGeneratorState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.endDate)
      ..writeByte(2)
      ..write(obj.dateCount)
      ..writeByte(3)
      ..write(obj.allowDuplicates)
      ..writeByte(4)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ColorGeneratorStateAdapter extends TypeAdapter<ColorGeneratorState> {
  @override
  final int typeId = 63;

  @override
  ColorGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ColorGeneratorState(
      withAlpha: fields[0] as bool,
      lastUpdated: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ColorGeneratorState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.withAlpha)
      ..writeByte(1)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DateTimeGeneratorStateAdapter
    extends TypeAdapter<DateTimeGeneratorState> {
  @override
  final int typeId = 64;

  @override
  DateTimeGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DateTimeGeneratorState(
      startDateTime: fields[0] as DateTime,
      endDateTime: fields[1] as DateTime,
      dateTimeCount: fields[2] as int,
      allowDuplicates: fields[3] as bool,
      lastUpdated: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DateTimeGeneratorState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.startDateTime)
      ..writeByte(1)
      ..write(obj.endDateTime)
      ..writeByte(2)
      ..write(obj.dateTimeCount)
      ..writeByte(3)
      ..write(obj.allowDuplicates)
      ..writeByte(4)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimeGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeGeneratorStateAdapter extends TypeAdapter<TimeGeneratorState> {
  @override
  final int typeId = 65;

  @override
  TimeGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeGeneratorState(
      startHour: fields[0] as int,
      startMinute: fields[1] as int,
      endHour: fields[2] as int,
      endMinute: fields[3] as int,
      timeCount: fields[4] as int,
      allowDuplicates: fields[5] as bool,
      lastUpdated: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TimeGeneratorState obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startHour)
      ..writeByte(1)
      ..write(obj.startMinute)
      ..writeByte(2)
      ..write(obj.endHour)
      ..writeByte(3)
      ..write(obj.endMinute)
      ..writeByte(4)
      ..write(obj.timeCount)
      ..writeByte(5)
      ..write(obj.allowDuplicates)
      ..writeByte(6)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlayingCardGeneratorStateAdapter
    extends TypeAdapter<PlayingCardGeneratorState> {
  @override
  final int typeId = 66;

  @override
  PlayingCardGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayingCardGeneratorState(
      includeJokers: fields[0] as bool,
      cardCount: fields[1] as int,
      allowDuplicates: fields[2] as bool,
      lastUpdated: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PlayingCardGeneratorState obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.includeJokers)
      ..writeByte(1)
      ..write(obj.cardCount)
      ..writeByte(2)
      ..write(obj.allowDuplicates)
      ..writeByte(3)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayingCardGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LatinLetterGeneratorStateAdapter
    extends TypeAdapter<LatinLetterGeneratorState> {
  @override
  final int typeId = 67;

  @override
  LatinLetterGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LatinLetterGeneratorState(
      includeUppercase: fields[0] as bool,
      includeLowercase: fields[1] as bool,
      letterCount: fields[2] as int,
      allowDuplicates: fields[3] as bool,
      skipAnimation: fields[4] as bool,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LatinLetterGeneratorState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.includeUppercase)
      ..writeByte(1)
      ..write(obj.includeLowercase)
      ..writeByte(2)
      ..write(obj.letterCount)
      ..writeByte(3)
      ..write(obj.allowDuplicates)
      ..writeByte(4)
      ..write(obj.skipAnimation)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatinLetterGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DiceRollGeneratorStateAdapter
    extends TypeAdapter<DiceRollGeneratorState> {
  @override
  final int typeId = 68;

  @override
  DiceRollGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiceRollGeneratorState(
      diceCount: fields[0] as int,
      diceSides: fields[1] as int,
      lastUpdated: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DiceRollGeneratorState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.diceCount)
      ..writeByte(1)
      ..write(obj.diceSides)
      ..writeByte(2)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiceRollGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SimpleGeneratorStateAdapter extends TypeAdapter<SimpleGeneratorState> {
  @override
  final int typeId = 69;

  @override
  SimpleGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SimpleGeneratorState(
      skipAnimation: fields[0] as bool,
      lastUpdated: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SimpleGeneratorState obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.skipAnimation)
      ..writeByte(1)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DiceRollGeneratorStateModelAdapter
    extends TypeAdapter<DiceRollGeneratorStateModel> {
  @override
  final int typeId = 44;

  @override
  DiceRollGeneratorStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiceRollGeneratorStateModel(
      diceCount: fields[0] as int,
      diceSides: fields[1] as int,
      lastUpdated: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DiceRollGeneratorStateModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.diceCount)
      ..writeByte(1)
      ..write(obj.diceSides)
      ..writeByte(2)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiceRollGeneratorStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeGeneratorStateModelAdapter
    extends TypeAdapter<TimeGeneratorStateModel> {
  @override
  final int typeId = 45;

  @override
  TimeGeneratorStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeGeneratorStateModel(
      startHour: fields[0] as int,
      startMinute: fields[1] as int,
      endHour: fields[2] as int,
      endMinute: fields[3] as int,
      timeCount: fields[4] as int,
      allowDuplicates: fields[5] as bool,
      lastUpdated: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TimeGeneratorStateModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startHour)
      ..writeByte(1)
      ..write(obj.startMinute)
      ..writeByte(2)
      ..write(obj.endHour)
      ..writeByte(3)
      ..write(obj.endMinute)
      ..writeByte(4)
      ..write(obj.timeCount)
      ..writeByte(5)
      ..write(obj.allowDuplicates)
      ..writeByte(6)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeGeneratorStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SimpleGeneratorStateModelAdapter
    extends TypeAdapter<SimpleGeneratorStateModel> {
  @override
  final int typeId = 46;

  @override
  SimpleGeneratorStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SimpleGeneratorStateModel(
      lastUpdated: fields[0] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SimpleGeneratorStateModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleGeneratorStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
