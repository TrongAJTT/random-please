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
      skipAnimation: fields[3] as bool,
      lastUpdated: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PlayingCardGeneratorState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.includeJokers)
      ..writeByte(1)
      ..write(obj.cardCount)
      ..writeByte(2)
      ..write(obj.allowDuplicates)
      ..writeByte(3)
      ..write(obj.skipAnimation)
      ..writeByte(4)
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

class YesNoGeneratorStateAdapter extends TypeAdapter<YesNoGeneratorState> {
  @override
  final int typeId = 70;

  @override
  YesNoGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YesNoGeneratorState(
      skipAnimation: fields[0] as bool,
      counterMode: fields[1] as bool,
      batchCount: fields[2] as int,
      result: fields[3] as String,
      lastUpdated: fields[4] as DateTime,
      isLoading: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, YesNoGeneratorState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.skipAnimation)
      ..writeByte(1)
      ..write(obj.counterMode)
      ..writeByte(2)
      ..write(obj.batchCount)
      ..writeByte(3)
      ..write(obj.result)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.isLoading);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YesNoGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CoinFlipGeneratorStateAdapter
    extends TypeAdapter<CoinFlipGeneratorState> {
  @override
  final int typeId = 75;

  @override
  CoinFlipGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoinFlipGeneratorState(
      skipAnimation: fields[0] as bool,
      counterMode: fields[1] as bool,
      batchCount: fields[2] as int,
      result: fields[3] as String,
      lastUpdated: fields[4] as DateTime,
      isLoading: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CoinFlipGeneratorState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.skipAnimation)
      ..writeByte(1)
      ..write(obj.counterMode)
      ..writeByte(2)
      ..write(obj.batchCount)
      ..writeByte(3)
      ..write(obj.result)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.isLoading);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoinFlipGeneratorStateAdapter &&
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

class RockPaperScissorsGeneratorStateAdapter
    extends TypeAdapter<RockPaperScissorsGeneratorState> {
  @override
  final int typeId = 79;

  @override
  RockPaperScissorsGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RockPaperScissorsGeneratorState(
      skipAnimation: fields[0] as bool,
      counterMode: fields[1] as bool,
      batchCount: fields[2] as int,
      result: fields[3] as String,
      lastUpdated: fields[4] as DateTime,
      isLoading: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RockPaperScissorsGeneratorState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.skipAnimation)
      ..writeByte(1)
      ..write(obj.counterMode)
      ..writeByte(2)
      ..write(obj.batchCount)
      ..writeByte(3)
      ..write(obj.result)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.isLoading);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RockPaperScissorsGeneratorStateAdapter &&
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

class LoremIpsumGeneratorStateAdapter
    extends TypeAdapter<LoremIpsumGeneratorState> {
  @override
  final int typeId = 74;

  @override
  LoremIpsumGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoremIpsumGeneratorState(
      generationType: fields[0] as LoremIpsumType,
      wordCount: fields[1] as int,
      sentenceCount: fields[2] as int,
      paragraphCount: fields[3] as int,
      startWithLorem: fields[4] as bool,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LoremIpsumGeneratorState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.generationType)
      ..writeByte(1)
      ..write(obj.wordCount)
      ..writeByte(2)
      ..write(obj.sentenceCount)
      ..writeByte(3)
      ..write(obj.paragraphCount)
      ..writeByte(4)
      ..write(obj.startWithLorem)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoremIpsumGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ListPickerGeneratorStateAdapter
    extends TypeAdapter<ListPickerGeneratorState> {
  @override
  final int typeId = 71;

  @override
  ListPickerGeneratorState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListPickerGeneratorState(
      quantity: fields[0] as int,
      currentList: fields[1] as CustomList?,
      savedLists: (fields[2] as List).cast<CustomList>(),
      lastUpdated: fields[3] as DateTime,
      mode: fields[4] as ListPickerMode,
      isListSelectorCollapsed: fields[5] as bool,
      listManagerExpandState: fields[6] as ListManagerExpandState,
    );
  }

  @override
  void write(BinaryWriter writer, ListPickerGeneratorState obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.currentList)
      ..writeByte(2)
      ..write(obj.savedLists)
      ..writeByte(3)
      ..write(obj.lastUpdated)
      ..writeByte(4)
      ..write(obj.mode)
      ..writeByte(5)
      ..write(obj.isListSelectorCollapsed)
      ..writeByte(6)
      ..write(obj.listManagerExpandState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListPickerGeneratorStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CustomListAdapter extends TypeAdapter<CustomList> {
  @override
  final int typeId = 72;

  @override
  CustomList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomList(
      id: fields[0] as String,
      name: fields[1] as String,
      items: (fields[2] as List).cast<ListItem>(),
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CustomList obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ListItemAdapter extends TypeAdapter<ListItem> {
  @override
  final int typeId = 73;

  @override
  ListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListItem(
      id: fields[0] as String,
      value: fields[1] as String,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ListItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LoremIpsumTypeAdapter extends TypeAdapter<LoremIpsumType> {
  @override
  final int typeId = 76;

  @override
  LoremIpsumType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LoremIpsumType.words;
      case 1:
        return LoremIpsumType.sentences;
      case 2:
        return LoremIpsumType.paragraphs;
      default:
        return LoremIpsumType.words;
    }
  }

  @override
  void write(BinaryWriter writer, LoremIpsumType obj) {
    switch (obj) {
      case LoremIpsumType.words:
        writer.writeByte(0);
        break;
      case LoremIpsumType.sentences:
        writer.writeByte(1);
        break;
      case LoremIpsumType.paragraphs:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoremIpsumTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ListPickerModeAdapter extends TypeAdapter<ListPickerMode> {
  @override
  final int typeId = 77;

  @override
  ListPickerMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ListPickerMode.random;
      case 1:
        return ListPickerMode.shuffle;
      case 2:
        return ListPickerMode.team;
      default:
        return ListPickerMode.random;
    }
  }

  @override
  void write(BinaryWriter writer, ListPickerMode obj) {
    switch (obj) {
      case ListPickerMode.random:
        writer.writeByte(0);
        break;
      case ListPickerMode.shuffle:
        writer.writeByte(1);
        break;
      case ListPickerMode.team:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListPickerModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ListManagerExpandStateAdapter
    extends TypeAdapter<ListManagerExpandState> {
  @override
  final int typeId = 78;

  @override
  ListManagerExpandState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ListManagerExpandState.expanded;
      case 1:
        return ListManagerExpandState.collapsed;
      case 2:
        return ListManagerExpandState.minimized;
      default:
        return ListManagerExpandState.expanded;
    }
  }

  @override
  void write(BinaryWriter writer, ListManagerExpandState obj) {
    switch (obj) {
      case ListManagerExpandState.expanded:
        writer.writeByte(0);
        break;
      case ListManagerExpandState.collapsed:
        writer.writeByte(1);
        break;
      case ListManagerExpandState.minimized:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListManagerExpandStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
