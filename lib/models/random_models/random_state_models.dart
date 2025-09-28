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
  final bool skipAnimation;
  @HiveField(4)
  final DateTime lastUpdated;

  PlayingCardGeneratorState({
    required this.includeJokers,
    required this.cardCount,
    required this.allowDuplicates,
    required this.skipAnimation,
    required this.lastUpdated,
  });

  static PlayingCardGeneratorState createDefault() {
    return PlayingCardGeneratorState(
      includeJokers: false,
      cardCount: 5,
      allowDuplicates: false,
      skipAnimation: false,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'includeJokers': includeJokers,
      'cardCount': cardCount,
      'allowDuplicates': allowDuplicates,
      'skipAnimation': skipAnimation,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory PlayingCardGeneratorState.fromJson(Map<String, dynamic> json) {
    return PlayingCardGeneratorState(
      includeJokers: json['includeJokers'] ?? false,
      cardCount: json['cardCount'] ?? 5,
      allowDuplicates: json['allowDuplicates'] ?? false,
      skipAnimation: json['skipAnimation'] ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  PlayingCardGeneratorState copyWith({
    bool? includeJokers,
    int? cardCount,
    bool? allowDuplicates,
    bool? skipAnimation,
  }) {
    return PlayingCardGeneratorState(
      includeJokers: includeJokers ?? this.includeJokers,
      cardCount: cardCount ?? this.cardCount,
      allowDuplicates: allowDuplicates ?? this.allowDuplicates,
      skipAnimation: skipAnimation ?? this.skipAnimation,
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

// Yes/No Generator State with Counter Mode
@HiveType(typeId: 70)
class YesNoGeneratorState {
  @HiveField(0)
  final bool skipAnimation;
  @HiveField(1)
  final bool counterMode;
  @HiveField(2)
  final int batchCount;
  @HiveField(3)
  final String result;
  @HiveField(4)
  final DateTime lastUpdated;
  @HiveField(5)
  final bool isLoading;

  YesNoGeneratorState({
    this.skipAnimation = false,
    this.counterMode = false,
    this.batchCount = 5,
    this.result = '',
    required this.lastUpdated,
    this.isLoading = false,
  });

  static YesNoGeneratorState createDefault() {
    return YesNoGeneratorState(
      skipAnimation: false,
      counterMode: false,
      batchCount: 5,
      result: '',
      lastUpdated: DateTime.now(),
      isLoading: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skipAnimation': skipAnimation,
      'counterMode': counterMode,
      'batchCount': batchCount,
      'result': result,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isLoading': isLoading,
    };
  }

  factory YesNoGeneratorState.fromJson(Map<String, dynamic> json) {
    return YesNoGeneratorState(
      skipAnimation: json['skipAnimation'] ?? false,
      counterMode: json['counterMode'] ?? false,
      batchCount: json['batchCount'] ?? 5,
      result: json['result'] ?? '',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      isLoading: json['isLoading'] ?? false,
    );
  }

  YesNoGeneratorState copyWith({
    bool? skipAnimation,
    bool? counterMode,
    int? batchCount,
    String? result,
    DateTime? lastUpdated,
    bool? isLoading,
  }) {
    return YesNoGeneratorState(
      skipAnimation: skipAnimation ?? this.skipAnimation,
      counterMode: counterMode ?? this.counterMode,
      batchCount: batchCount ?? this.batchCount,
      result: result ?? this.result,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Coin Flip Generator State with Counter Mode
@HiveType(typeId: 75)
class CoinFlipGeneratorState {
  @HiveField(0)
  final bool skipAnimation;
  @HiveField(1)
  final bool counterMode;
  @HiveField(2)
  final int batchCount;
  @HiveField(3)
  final String result;
  @HiveField(4)
  final DateTime lastUpdated;
  @HiveField(5)
  final bool isLoading;

  CoinFlipGeneratorState({
    this.skipAnimation = false,
    this.counterMode = false,
    this.batchCount = 5,
    this.result = '',
    required this.lastUpdated,
    this.isLoading = false,
  });

  static CoinFlipGeneratorState createDefault() {
    return CoinFlipGeneratorState(
      skipAnimation: false,
      counterMode: false,
      batchCount: 5,
      result: '',
      lastUpdated: DateTime.now(),
      isLoading: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skipAnimation': skipAnimation,
      'counterMode': counterMode,
      'batchCount': batchCount,
      'result': result,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isLoading': isLoading,
    };
  }

  factory CoinFlipGeneratorState.fromJson(Map<String, dynamic> json) {
    return CoinFlipGeneratorState(
      skipAnimation: json['skipAnimation'] ?? false,
      counterMode: json['counterMode'] ?? false,
      batchCount: json['batchCount'] ?? 5,
      result: json['result'] ?? '',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      isLoading: json['isLoading'] ?? false,
    );
  }

  CoinFlipGeneratorState copyWith({
    bool? skipAnimation,
    bool? counterMode,
    int? batchCount,
    String? result,
    DateTime? lastUpdated,
    bool? isLoading,
  }) {
    return CoinFlipGeneratorState(
      skipAnimation: skipAnimation ?? this.skipAnimation,
      counterMode: counterMode ?? this.counterMode,
      batchCount: batchCount ?? this.batchCount,
      result: result ?? this.result,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Counter Statistics Model (not saved to state)
class CounterStatistics {
  final DateTime startTime;
  final int totalGenerations;
  final int yesCount;
  final int noCount;

  CounterStatistics({
    required this.startTime,
    this.totalGenerations = 0,
    this.yesCount = 0,
    this.noCount = 0,
  });

  CounterStatistics copyWith({
    DateTime? startTime,
    int? totalGenerations,
    int? yesCount,
    int? noCount,
  }) {
    return CounterStatistics(
      startTime: startTime ?? this.startTime,
      totalGenerations: totalGenerations ?? this.totalGenerations,
      yesCount: yesCount ?? this.yesCount,
      noCount: noCount ?? this.noCount,
    );
  }

  double get yesPercentage {
    if (totalGenerations == 0) return 0.0;
    return (yesCount / totalGenerations) * 100;
  }

  double get noPercentage {
    if (totalGenerations == 0) return 0.0;
    return (noCount / totalGenerations) * 100;
  }
}

// Coin Flip Counter Statistics Model (not saved to state)
class CoinFlipCounterStatistics {
  final DateTime startTime;
  final int totalGenerations;
  final int headsCount;
  final int tailsCount;

  CoinFlipCounterStatistics({
    required this.startTime,
    this.totalGenerations = 0,
    this.headsCount = 0,
    this.tailsCount = 0,
  });

  CoinFlipCounterStatistics copyWith({
    DateTime? startTime,
    int? totalGenerations,
    int? headsCount,
    int? tailsCount,
  }) {
    return CoinFlipCounterStatistics(
      startTime: startTime ?? this.startTime,
      totalGenerations: totalGenerations ?? this.totalGenerations,
      headsCount: headsCount ?? this.headsCount,
      tailsCount: tailsCount ?? this.tailsCount,
    );
  }

  double get headsPercentage {
    if (totalGenerations == 0) return 0.0;
    return (headsCount / totalGenerations) * 100;
  }

  double get tailsPercentage {
    if (totalGenerations == 0) return 0.0;
    return (tailsCount / totalGenerations) * 100;
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

// Rock Paper Scissors Generator State with Counter Mode
@HiveType(typeId: 79)
class RockPaperScissorsGeneratorState {
  @HiveField(0)
  final bool skipAnimation;
  @HiveField(1)
  final bool counterMode;
  @HiveField(2)
  final int batchCount;
  @HiveField(3)
  final String result;
  @HiveField(4)
  final DateTime lastUpdated;
  @HiveField(5)
  final bool isLoading;

  RockPaperScissorsGeneratorState({
    this.skipAnimation = false,
    this.counterMode = false,
    this.batchCount = 5,
    this.result = '',
    required this.lastUpdated,
    this.isLoading = false,
  });

  static RockPaperScissorsGeneratorState createDefault() {
    return RockPaperScissorsGeneratorState(
      skipAnimation: false,
      counterMode: false,
      batchCount: 5,
      result: '',
      lastUpdated: DateTime.now(),
      isLoading: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skipAnimation': skipAnimation,
      'counterMode': counterMode,
      'batchCount': batchCount,
      'result': result,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isLoading': isLoading,
    };
  }

  factory RockPaperScissorsGeneratorState.fromJson(Map<String, dynamic> json) {
    return RockPaperScissorsGeneratorState(
      skipAnimation: json['skipAnimation'] ?? false,
      counterMode: json['counterMode'] ?? false,
      batchCount: json['batchCount'] ?? 5,
      result: json['result'] ?? '',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
      isLoading: json['isLoading'] ?? false,
    );
  }

  RockPaperScissorsGeneratorState copyWith({
    bool? skipAnimation,
    bool? counterMode,
    int? batchCount,
    String? result,
    DateTime? lastUpdated,
    bool? isLoading,
  }) {
    return RockPaperScissorsGeneratorState(
      skipAnimation: skipAnimation ?? this.skipAnimation,
      counterMode: counterMode ?? this.counterMode,
      batchCount: batchCount ?? this.batchCount,
      result: result ?? this.result,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Rock Paper Scissors Counter Statistics Model (not saved to state)
class RockPaperScissorsCounterStatistics {
  final DateTime startTime;
  final int totalGenerations;
  final int rockCount;
  final int paperCount;
  final int scissorsCount;

  RockPaperScissorsCounterStatistics({
    required this.startTime,
    this.totalGenerations = 0,
    this.rockCount = 0,
    this.paperCount = 0,
    this.scissorsCount = 0,
  });

  RockPaperScissorsCounterStatistics copyWith({
    DateTime? startTime,
    int? totalGenerations,
    int? rockCount,
    int? paperCount,
    int? scissorsCount,
  }) {
    return RockPaperScissorsCounterStatistics(
      startTime: startTime ?? this.startTime,
      totalGenerations: totalGenerations ?? this.totalGenerations,
      rockCount: rockCount ?? this.rockCount,
      paperCount: paperCount ?? this.paperCount,
      scissorsCount: scissorsCount ?? this.scissorsCount,
    );
  }

  double get rockPercentage {
    if (totalGenerations == 0) return 0.0;
    return (rockCount / totalGenerations) * 100;
  }

  double get paperPercentage {
    if (totalGenerations == 0) return 0.0;
    return (paperCount / totalGenerations) * 100;
  }

  double get scissorsPercentage {
    if (totalGenerations == 0) return 0.0;
    return (scissorsCount / totalGenerations) * 100;
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

// Lorem Ipsum generator state
@HiveType(typeId: 76)
enum LoremIpsumType {
  @HiveField(0)
  words,
  @HiveField(1)
  sentences,
  @HiveField(2)
  paragraphs
}

@HiveType(typeId: 74)
class LoremIpsumGeneratorState {
  @HiveField(0)
  final LoremIpsumType generationType;
  @HiveField(1)
  final int wordCount;
  @HiveField(2)
  final int sentenceCount;
  @HiveField(3)
  final int paragraphCount;
  @HiveField(4)
  final bool startWithLorem;
  @HiveField(5)
  final DateTime lastUpdated;

  LoremIpsumGeneratorState({
    required this.generationType,
    required this.wordCount,
    required this.sentenceCount,
    required this.paragraphCount,
    required this.startWithLorem,
    required this.lastUpdated,
  });

  static LoremIpsumGeneratorState createDefault() {
    return LoremIpsumGeneratorState(
      generationType: LoremIpsumType.sentences,
      wordCount: 50,
      sentenceCount: 5,
      paragraphCount: 3,
      startWithLorem: true,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'generationType': generationType.index,
      'wordCount': wordCount,
      'sentenceCount': sentenceCount,
      'paragraphCount': paragraphCount,
      'startWithLorem': startWithLorem,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory LoremIpsumGeneratorState.fromJson(Map<String, dynamic> json) {
    return LoremIpsumGeneratorState(
      generationType: LoremIpsumType.values[json['generationType'] ?? 1],
      wordCount: json['wordCount'] ?? 50,
      sentenceCount: json['sentenceCount'] ?? 5,
      paragraphCount: json['paragraphCount'] ?? 3,
      startWithLorem: json['startWithLorem'] ?? true,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  LoremIpsumGeneratorState copyWith({
    LoremIpsumType? generationType,
    int? wordCount,
    int? sentenceCount,
    int? paragraphCount,
    bool? startWithLorem,
  }) {
    return LoremIpsumGeneratorState(
      generationType: generationType ?? this.generationType,
      wordCount: wordCount ?? this.wordCount,
      sentenceCount: sentenceCount ?? this.sentenceCount,
      paragraphCount: paragraphCount ?? this.paragraphCount,
      startWithLorem: startWithLorem ?? this.startWithLorem,
      lastUpdated: DateTime.now(),
    );
  }
}

// List Picker generator state
@HiveType(typeId: 77)
enum ListPickerMode {
  @HiveField(0)
  random,
  @HiveField(1)
  shuffle,
  @HiveField(2)
  team,
}

@HiveType(typeId: 78)
enum ListManagerExpandState {
  @HiveField(0)
  expanded, // Hiển thị full content
  @HiveField(1)
  collapsed, // Hiển thị một phần như trong ảnh
  @HiveField(2)
  minimized, // Chỉ hiển thị header
}

@HiveType(typeId: 71)
class ListPickerGeneratorState {
  @HiveField(0)
  int quantity;

  @HiveField(1)
  CustomList? currentList;

  @HiveField(2)
  List<CustomList> savedLists;

  @HiveField(3)
  DateTime lastUpdated;

  @HiveField(4)
  ListPickerMode mode;

  @HiveField(5)
  bool isListSelectorCollapsed;

  @HiveField(6)
  ListManagerExpandState listManagerExpandState;

  ListPickerGeneratorState({
    required this.quantity,
    this.currentList,
    required this.savedLists,
    required this.lastUpdated,
    this.mode = ListPickerMode.random,
    this.isListSelectorCollapsed = false,
    this.listManagerExpandState = ListManagerExpandState.expanded,
  });

  static ListPickerGeneratorState createDefault() {
    return ListPickerGeneratorState(
      quantity: 1,
      currentList: null,
      savedLists: [],
      lastUpdated: DateTime.now(),
      mode: ListPickerMode.random,
      isListSelectorCollapsed: false,
      listManagerExpandState: ListManagerExpandState.expanded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'currentList': currentList?.toJson(),
      'savedLists': savedLists.map((list) => list.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'mode': mode.name,
      'isListSelectorCollapsed': isListSelectorCollapsed,
      'listManagerExpandState': listManagerExpandState.name,
    };
  }

  factory ListPickerGeneratorState.fromJson(Map<String, dynamic> json) {
    return ListPickerGeneratorState(
      quantity: json['quantity'] ?? 1,
      currentList: json['currentList'] != null
          ? CustomList.fromJson(json['currentList'])
          : null,
      savedLists: (json['savedLists'] as List<dynamic>?)
              ?.map((listJson) => CustomList.fromJson(listJson))
              .toList() ??
          [],
      lastUpdated: DateTime.parse(
          json['lastUpdated'] ?? DateTime.now().toIso8601String()),
      mode: ListPickerMode.values.firstWhere(
        (mode) => mode.name == (json['mode'] ?? 'random'),
        orElse: () => ListPickerMode.random,
      ),
      isListSelectorCollapsed: json['isListSelectorCollapsed'] ?? false,
      listManagerExpandState: ListManagerExpandState.values.firstWhere(
        (state) => state.name == (json['listManagerExpandState'] ?? 'expanded'),
        orElse: () => ListManagerExpandState.expanded,
      ),
    );
  }

  ListPickerGeneratorState copyWith({
    int? quantity,
    CustomList? currentList,
    List<CustomList>? savedLists,
    DateTime? lastUpdated,
    ListPickerMode? mode,
    bool? isListSelectorCollapsed,
    ListManagerExpandState? listManagerExpandState,
  }) {
    return ListPickerGeneratorState(
      quantity: quantity ?? this.quantity,
      currentList: currentList ?? this.currentList,
      savedLists: savedLists ?? this.savedLists,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      mode: mode ?? this.mode,
      isListSelectorCollapsed:
          isListSelectorCollapsed ?? this.isListSelectorCollapsed,
      listManagerExpandState:
          listManagerExpandState ?? this.listManagerExpandState,
    );
  }
}

@HiveType(typeId: 72)
class CustomList {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<ListItem> items;

  @HiveField(3)
  DateTime createdAt;

  CustomList({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomList.fromJson(Map<String, dynamic> json) {
    return CustomList(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((itemJson) => ListItem.fromJson(itemJson))
              .toList() ??
          [],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

@HiveType(typeId: 73)
class ListItem {
  @HiveField(0)
  String id;

  @HiveField(1)
  String value;

  @HiveField(2)
  DateTime createdAt;

  ListItem({
    required this.id,
    required this.value,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      id: json['id'] ?? '',
      value: json['value'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
