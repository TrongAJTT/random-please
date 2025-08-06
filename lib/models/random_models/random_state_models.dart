import 'package:hive/hive.dart';

part 'random_state_models.g.dart';

// Simple JSON-based state models for random generators
@HiveType(typeId: 60)
class NumberGeneratorState {
  @HiveField(0)
  final bool isInteger;
  @HiveField(1)
  final double minValue;
  @HiveField(2)
  final double maxValue;
  @HiveField(3)
  final int quantity;
  @HiveField(4)
  final bool allowDuplicates;
  @HiveField(5)
  final DateTime lastUpdated;

  NumberGeneratorState({
    required this.isInteger,
    required this.minValue,
    required this.maxValue,
    required this.quantity,
    required this.allowDuplicates,
    required this.lastUpdated,
  });

  static NumberGeneratorState createDefault() {
    return NumberGeneratorState(
      isInteger: true,
      minValue: 1.0,
      maxValue: 100.0,
      quantity: 5,
      allowDuplicates: true,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isInteger': isInteger,
      'minValue': minValue,
      'maxValue': maxValue,
      'quantity': quantity,
      'allowDuplicates': allowDuplicates,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory NumberGeneratorState.fromJson(Map<String, dynamic> json) {
    return NumberGeneratorState(
      isInteger: json['isInteger'] ?? true,
      minValue: (json['minValue'] as num?)?.toDouble() ?? 1.0,
      maxValue: (json['maxValue'] as num?)?.toDouble() ?? 100.0,
      quantity: json['quantity'] ?? 5,
      allowDuplicates: json['allowDuplicates'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  NumberGeneratorState copyWith({
    bool? isInteger,
    double? minValue,
    double? maxValue,
    int? quantity,
    bool? allowDuplicates,
  }) {
    return NumberGeneratorState(
      isInteger: isInteger ?? this.isInteger,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      quantity: quantity ?? this.quantity,
      allowDuplicates: allowDuplicates ?? this.allowDuplicates,
      lastUpdated: DateTime.now(),
    );
  }
}

@HiveType(typeId: 61)
class PasswordGeneratorState {
  @HiveField(0)
  final int passwordLength;
  @HiveField(1)
  final bool includeLowercase;
  @HiveField(2)
  final bool includeUppercase;
  @HiveField(3)
  final bool includeNumbers;
  @HiveField(4)
  final bool includeSpecial;
  @HiveField(5)
  final DateTime lastUpdated;

  PasswordGeneratorState({
    required this.passwordLength,
    required this.includeLowercase,
    required this.includeUppercase,
    required this.includeNumbers,
    required this.includeSpecial,
    required this.lastUpdated,
  });

  static PasswordGeneratorState createDefault() {
    return PasswordGeneratorState(
      passwordLength: 12,
      includeLowercase: true,
      includeUppercase: true,
      includeNumbers: true,
      includeSpecial: true,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passwordLength': passwordLength,
      'includeLowercase': includeLowercase,
      'includeUppercase': includeUppercase,
      'includeNumbers': includeNumbers,
      'includeSpecial': includeSpecial,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory PasswordGeneratorState.fromJson(Map<String, dynamic> json) {
    return PasswordGeneratorState(
      passwordLength: json['passwordLength'] ?? 12,
      includeLowercase: json['includeLowercase'] ?? true,
      includeUppercase: json['includeUppercase'] ?? true,
      includeNumbers: json['includeNumbers'] ?? true,
      includeSpecial: json['includeSpecial'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  PasswordGeneratorState copyWith({
    int? passwordLength,
    bool? includeLowercase,
    bool? includeUppercase,
    bool? includeNumbers,
    bool? includeSpecial,
  }) {
    return PasswordGeneratorState(
      passwordLength: passwordLength ?? this.passwordLength,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeNumbers: includeNumbers ?? this.includeNumbers,
      includeSpecial: includeSpecial ?? this.includeSpecial,
      lastUpdated: DateTime.now(),
    );
  }
}

@HiveType(typeId: 62)
class DateGeneratorState {
  @HiveField(0)
  final DateTime startDate;
  @HiveField(1)
  final DateTime endDate;
  @HiveField(2)
  final int dateCount;
  @HiveField(3)
  final bool allowDuplicates;
  @HiveField(4)
  final DateTime lastUpdated;

  DateGeneratorState({
    required this.startDate,
    required this.endDate,
    required this.dateCount,
    required this.allowDuplicates,
    required this.lastUpdated,
  });

  static DateGeneratorState createDefault() {
    final now = DateTime.now();
    return DateGeneratorState(
      startDate: now.subtract(const Duration(days: 365)),
      endDate: now.add(const Duration(days: 365)),
      dateCount: 5,
      allowDuplicates: true,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'dateCount': dateCount,
      'allowDuplicates': allowDuplicates,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DateGeneratorState.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return DateGeneratorState(
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : now.subtract(const Duration(days: 365)),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : now.add(const Duration(days: 365)),
      dateCount: json['dateCount'] ?? 5,
      allowDuplicates: json['allowDuplicates'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  DateGeneratorState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? dateCount,
    bool? allowDuplicates,
  }) {
    return DateGeneratorState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dateCount: dateCount ?? this.dateCount,
      allowDuplicates: allowDuplicates ?? this.allowDuplicates,
      lastUpdated: DateTime.now(),
    );
  }
}

@HiveType(typeId: 63)
class ColorGeneratorState {
  @HiveField(0)
  final bool withAlpha;
  @HiveField(1)
  final DateTime lastUpdated;

  ColorGeneratorState({
    required this.withAlpha,
    required this.lastUpdated,
  });

  static ColorGeneratorState createDefault() {
    return ColorGeneratorState(
      withAlpha: false,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'withAlpha': withAlpha,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory ColorGeneratorState.fromJson(Map<String, dynamic> json) {
    return ColorGeneratorState(
      withAlpha: json['withAlpha'] ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  ColorGeneratorState copyWith({
    bool? withAlpha,
  }) {
    return ColorGeneratorState(
      withAlpha: withAlpha ?? this.withAlpha,
      lastUpdated: DateTime.now(),
    );
  }
}

// Date Time Generator State
@HiveType(typeId: 64)
class DateTimeGeneratorState {
  @HiveField(0)
  final DateTime startDateTime;
  @HiveField(1)
  final DateTime endDateTime;
  @HiveField(2)
  final int dateTimeCount;
  @HiveField(3)
  final bool allowDuplicates;
  @HiveField(4)
  final DateTime lastUpdated;

  DateTimeGeneratorState({
    required this.startDateTime,
    required this.endDateTime,
    required this.dateTimeCount,
    required this.allowDuplicates,
    required this.lastUpdated,
  });

  static DateTimeGeneratorState createDefault() {
    final now = DateTime.now();
    return DateTimeGeneratorState(
      startDateTime: now.subtract(const Duration(days: 365)),
      endDateTime: now.add(const Duration(days: 365)),
      dateTimeCount: 5,
      allowDuplicates: true,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'dateTimeCount': dateTimeCount,
      'allowDuplicates': allowDuplicates,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DateTimeGeneratorState.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return DateTimeGeneratorState(
      startDateTime: json['startDateTime'] != null
          ? DateTime.parse(json['startDateTime'])
          : now.subtract(const Duration(days: 365)),
      endDateTime: json['endDateTime'] != null
          ? DateTime.parse(json['endDateTime'])
          : now.add(const Duration(days: 365)),
      dateTimeCount: json['dateTimeCount'] ?? 5,
      allowDuplicates: json['allowDuplicates'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  DateTimeGeneratorState copyWith({
    DateTime? startDateTime,
    DateTime? endDateTime,
    int? dateTimeCount,
    bool? allowDuplicates,
  }) {
    return DateTimeGeneratorState(
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      dateTimeCount: dateTimeCount ?? this.dateTimeCount,
      allowDuplicates: allowDuplicates ?? this.allowDuplicates,
      lastUpdated: DateTime.now(),
    );
  }
}

// Time Generator State
@HiveType(typeId: 65)
class TimeGeneratorState {
  @HiveField(0)
  final int startHour;
  @HiveField(1)
  final int startMinute;
  @HiveField(2)
  final int endHour;
  @HiveField(3)
  final int endMinute;
  @HiveField(4)
  final int timeCount;
  @HiveField(5)
  final bool allowDuplicates;
  @HiveField(6)
  final DateTime lastUpdated;

  TimeGeneratorState({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.timeCount,
    required this.allowDuplicates,
    required this.lastUpdated,
  });

  static TimeGeneratorState createDefault() {
    return TimeGeneratorState(
      startHour: 0,
      startMinute: 0,
      endHour: 23,
      endMinute: 59,
      timeCount: 5,
      allowDuplicates: true,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startHour': startHour,
      'startMinute': startMinute,
      'endHour': endHour,
      'endMinute': endMinute,
      'timeCount': timeCount,
      'allowDuplicates': allowDuplicates,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory TimeGeneratorState.fromJson(Map<String, dynamic> json) {
    return TimeGeneratorState(
      startHour: json['startHour'] ?? 0,
      startMinute: json['startMinute'] ?? 0,
      endHour: json['endHour'] ?? 23,
      endMinute: json['endMinute'] ?? 59,
      timeCount: json['timeCount'] ?? 5,
      allowDuplicates: json['allowDuplicates'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  TimeGeneratorState copyWith({
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    int? timeCount,
    bool? allowDuplicates,
  }) {
    return TimeGeneratorState(
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      timeCount: timeCount ?? this.timeCount,
      allowDuplicates: allowDuplicates ?? this.allowDuplicates,
      lastUpdated: DateTime.now(),
    );
  }
}

// Playing Card Generator State
@HiveType(typeId: 66)
class PlayingCardGeneratorState {
  @HiveField(0)
  final bool includeJokers;
  @HiveField(1)
  final int cardCount;
  @HiveField(2)
  final bool allowDuplicates;
  @HiveField(3)
  final DateTime lastUpdated;

  PlayingCardGeneratorState({
    required this.includeJokers,
    required this.cardCount,
    required this.allowDuplicates,
    required this.lastUpdated,
  });

  static PlayingCardGeneratorState createDefault() {
    return PlayingCardGeneratorState(
      includeJokers: false,
      cardCount: 5,
      allowDuplicates: false,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'includeJokers': includeJokers,
      'cardCount': cardCount,
      'allowDuplicates': allowDuplicates,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory PlayingCardGeneratorState.fromJson(Map<String, dynamic> json) {
    return PlayingCardGeneratorState(
      includeJokers: json['includeJokers'] ?? false,
      cardCount: json['cardCount'] ?? 5,
      allowDuplicates: json['allowDuplicates'] ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  PlayingCardGeneratorState copyWith({
    bool? includeJokers,
    int? cardCount,
    bool? allowDuplicates,
  }) {
    return PlayingCardGeneratorState(
      includeJokers: includeJokers ?? this.includeJokers,
      cardCount: cardCount ?? this.cardCount,
      allowDuplicates: allowDuplicates ?? this.allowDuplicates,
      lastUpdated: DateTime.now(),
    );
  }
}

// Latin Letter Generator State
@HiveType(typeId: 67)
class LatinLetterGeneratorState {
  @HiveField(0)
  final bool includeUppercase;
  @HiveField(1)
  final bool includeLowercase;
  @HiveField(2)
  final int letterCount;
  @HiveField(3)
  final bool allowDuplicates;
  @HiveField(4)
  final bool skipAnimation;
  @HiveField(5)
  final DateTime lastUpdated;

  LatinLetterGeneratorState({
    required this.includeUppercase,
    required this.includeLowercase,
    required this.letterCount,
    required this.allowDuplicates,
    this.skipAnimation = false,
    required this.lastUpdated,
  });

  static LatinLetterGeneratorState createDefault() {
    return LatinLetterGeneratorState(
      includeUppercase: true,
      includeLowercase: true,
      letterCount: 5,
      allowDuplicates: true,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'includeUppercase': includeUppercase,
      'includeLowercase': includeLowercase,
      'letterCount': letterCount,
      'allowDuplicates': allowDuplicates,
      'skipAnimation': skipAnimation,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory LatinLetterGeneratorState.fromJson(Map<String, dynamic> json) {
    return LatinLetterGeneratorState(
      includeUppercase: json['includeUppercase'] ?? true,
      includeLowercase: json['includeLowercase'] ?? true,
      letterCount: json['letterCount'] ?? 5,
      allowDuplicates: json['allowDuplicates'] ?? true,
      skipAnimation: json['skipAnimation'] ?? false,
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  LatinLetterGeneratorState copyWith({
    bool? includeUppercase,
    bool? includeLowercase,
    int? letterCount,
    bool? allowDuplicates,
    bool? skipAnimation,
  }) {
    return LatinLetterGeneratorState(
      includeUppercase: includeUppercase ?? this.includeUppercase,
      includeLowercase: includeLowercase ?? this.includeLowercase,
      letterCount: letterCount ?? this.letterCount,
      allowDuplicates: allowDuplicates ?? this.allowDuplicates,
      skipAnimation: skipAnimation ?? this.skipAnimation,
      lastUpdated: DateTime.now(),
    );
  }
}

// Dice Roll Generator State
@HiveType(typeId: 68)
class DiceRollGeneratorState {
  @HiveField(0)
  final int diceCount;
  @HiveField(1)
  final int diceSides;
  @HiveField(2)
  final DateTime lastUpdated;

  DiceRollGeneratorState({
    required this.diceCount,
    required this.diceSides,
    required this.lastUpdated,
  });

  static DiceRollGeneratorState createDefault() {
    return DiceRollGeneratorState(
      diceCount: 1,
      diceSides: 6,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diceCount': diceCount,
      'diceSides': diceSides,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DiceRollGeneratorState.fromJson(Map<String, dynamic> json) {
    return DiceRollGeneratorState(
      diceCount: json['diceCount'] ?? 1,
      diceSides: json['diceSides'] ?? 6,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  DiceRollGeneratorState copyWith({
    int? diceCount,
    int? diceSides,
  }) {
    return DiceRollGeneratorState(
      diceCount: diceCount ?? this.diceCount,
      diceSides: diceSides ?? this.diceSides,
      lastUpdated: DateTime.now(),
    );
  }
}

// Simple state for tools with minimal options (Yes/No, Coin Flip, Rock Paper Scissors)
@HiveType(typeId: 69)
class SimpleGeneratorState {
  @HiveField(0)
  final bool skipAnimation;
  @HiveField(1)
  final DateTime lastUpdated;

  SimpleGeneratorState({
    this.skipAnimation = false,
    required this.lastUpdated,
  });

  static SimpleGeneratorState createDefault() {
    return SimpleGeneratorState(
      skipAnimation: false,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skipAnimation': skipAnimation,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory SimpleGeneratorState.fromJson(Map<String, dynamic> json) {
    return SimpleGeneratorState(
      skipAnimation: json['skipAnimation'] ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  SimpleGeneratorState copyWith({
    bool? skipAnimation,
  }) {
    return SimpleGeneratorState(
      skipAnimation: skipAnimation ?? this.skipAnimation,
      lastUpdated: DateTime.now(),
    );
  }
}

// Dice Roll Generator State Model
@HiveType(typeId: 44)
class DiceRollGeneratorStateModel extends HiveObject {
  @HiveField(0)
  int diceCount;

  @HiveField(1)
  int diceSides;

  @HiveField(2)
  DateTime lastUpdated;

  DiceRollGeneratorStateModel({
    required this.diceCount,
    required this.diceSides,
    required this.lastUpdated,
  });

  static DiceRollGeneratorStateModel createDefault() {
    return DiceRollGeneratorStateModel(
      diceCount: 1,
      diceSides: 6,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diceCount': diceCount,
      'diceSides': diceSides,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DiceRollGeneratorStateModel.fromJson(Map<String, dynamic> json) {
    return DiceRollGeneratorStateModel(
      diceCount: json['diceCount'] ?? 1,
      diceSides: json['diceSides'] ?? 6,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  DiceRollGeneratorStateModel copyWith({
    int? diceCount,
    int? diceSides,
  }) {
    return DiceRollGeneratorStateModel(
      diceCount: diceCount ?? this.diceCount,
      diceSides: diceSides ?? this.diceSides,
      lastUpdated: DateTime.now(),
    );
  }
}

// Time Generator State Model
@HiveType(typeId: 45)
class TimeGeneratorStateModel extends HiveObject {
  @HiveField(0)
  int startHour;

  @HiveField(1)
  int startMinute;

  @HiveField(2)
  int endHour;

  @HiveField(3)
  int endMinute;

  @HiveField(4)
  int timeCount;

  @HiveField(5)
  bool allowDuplicates;

  @HiveField(6)
  DateTime lastUpdated;

  TimeGeneratorStateModel({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.timeCount,
    required this.allowDuplicates,
    required this.lastUpdated,
  });

  static TimeGeneratorStateModel createDefault() {
    return TimeGeneratorStateModel(
      startHour: 0,
      startMinute: 0,
      endHour: 23,
      endMinute: 59,
      timeCount: 5,
      allowDuplicates: true,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startHour': startHour,
      'startMinute': startMinute,
      'endHour': endHour,
      'endMinute': endMinute,
      'timeCount': timeCount,
      'allowDuplicates': allowDuplicates,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory TimeGeneratorStateModel.fromJson(Map<String, dynamic> json) {
    return TimeGeneratorStateModel(
      startHour: json['startHour'] ?? 0,
      startMinute: json['startMinute'] ?? 0,
      endHour: json['endHour'] ?? 23,
      endMinute: json['endMinute'] ?? 59,
      timeCount: json['timeCount'] ?? 5,
      allowDuplicates: json['allowDuplicates'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  TimeGeneratorStateModel copyWith({
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    int? timeCount,
    bool? allowDuplicates,
  }) {
    return TimeGeneratorStateModel(
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      timeCount: timeCount ?? this.timeCount,
      allowDuplicates: allowDuplicates ?? this.allowDuplicates,
      lastUpdated: DateTime.now(),
    );
  }
}

// Simple state models for tools with minimal options
@HiveType(typeId: 46)
class SimpleGeneratorStateModel extends HiveObject {
  @HiveField(0)
  DateTime lastUpdated;

  SimpleGeneratorStateModel({
    required this.lastUpdated,
  });

  static SimpleGeneratorStateModel createDefault() {
    return SimpleGeneratorStateModel(
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory SimpleGeneratorStateModel.fromJson(Map<String, dynamic> json) {
    return SimpleGeneratorStateModel(
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  SimpleGeneratorStateModel copyWith() {
    return SimpleGeneratorStateModel(
      lastUpdated: DateTime.now(),
    );
  }
}
