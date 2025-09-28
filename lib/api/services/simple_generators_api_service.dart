import 'dart:math';
import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';

// Simple generators for coin, dice, rps, yesno theo CustomAPI.md

// === COIN FLIP GENERATOR ===
class CoinApiConfig extends ApiConfig {
  final int quantity;

  CoinApiConfig({required this.quantity});

  factory CoinApiConfig.fromJson(Map<String, dynamic> json) {
    return CoinApiConfig(
      quantity: _parseInt(json['quantity']) ?? 10,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => {'quantity': quantity};

  @override
  bool isValid() => quantity > 0 && quantity <= 1000;
}

class CoinApiResult extends ApiResult {
  final List<String> results;
  final CoinApiConfig config;

  CoinApiResult({required this.results, required this.config});

  @override
  Map<String, dynamic> toJson() {
    return {
      'results': results,
      'count': results.length,
      'config': config.toJson(),
    };
  }
}

class CoinApiService
    implements ApiRandomGenerator<CoinApiConfig, CoinApiResult> {
  final Random _random = Random();

  @override
  String get generatorName => 'coin';

  @override
  String get description => 'Flip coins and get heads or tails';

  @override
  String get version => '1.0.0';

  @override
  Future<CoinApiResult> generate(CoinApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for coin generator');
    }

    final results = List.generate(
      config.quantity,
      (index) => _random.nextBool() ? 'Heads' : 'Tails',
    );

    return CoinApiResult(results: results, config: config);
  }

  @override
  bool validateConfig(CoinApiConfig config) => config.isValid();

  @override
  CoinApiConfig getDefaultConfig() => CoinApiConfig(quantity: 10);

  @override
  Map<String, dynamic> resultToJson(CoinApiResult result) {
    return {
      'data': result.results, // Chỉ array kết quả
      'metadata': {
        'count': result.results.length,
        'config': result.config.toJson(),
        'generator': 'coin',
        'version': '1.0.0',
      },
    };
  }

  @override
  CoinApiConfig parseConfig(Map<String, dynamic> params) =>
      CoinApiConfig.fromJson(params);
}

// === DICE ROLL GENERATOR ===
class DiceApiConfig extends ApiConfig {
  final int quantity;
  final int sides;

  DiceApiConfig({required this.quantity, required this.sides});

  factory DiceApiConfig.fromJson(Map<String, dynamic> json) {
    return DiceApiConfig(
      quantity: _parseInt(json['quantity']) ?? 10,
      sides: _parseInt(json['sides']) ?? 6,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => {'quantity': quantity, 'sides': sides};

  @override
  bool isValid() =>
      quantity > 0 && quantity <= 1000 && sides > 0 && sides <= 100;
}

class DiceApiResult extends ApiResult {
  final List<int> results;
  final DiceApiConfig config;

  DiceApiResult({required this.results, required this.config});

  @override
  Map<String, dynamic> toJson() {
    return {
      'results': results,
      'count': results.length,
      'config': config.toJson(),
    };
  }
}

class DiceApiService
    implements ApiRandomGenerator<DiceApiConfig, DiceApiResult> {
  final Random _random = Random();

  @override
  String get generatorName => 'dice';

  @override
  String get description => 'Roll dice with customizable number of sides';

  @override
  String get version => '1.0.0';

  @override
  Future<DiceApiResult> generate(DiceApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for dice generator');
    }

    final results = List.generate(
      config.quantity,
      (index) => _random.nextInt(config.sides) + 1,
    );

    return DiceApiResult(results: results, config: config);
  }

  @override
  bool validateConfig(DiceApiConfig config) => config.isValid();

  @override
  DiceApiConfig getDefaultConfig() => DiceApiConfig(quantity: 10, sides: 6);

  @override
  Map<String, dynamic> resultToJson(DiceApiResult result) {
    return {
      'data': result.results, // Chỉ array kết quả
      'metadata': {
        'count': result.results.length,
        'config': result.config.toJson(),
        'generator': 'dice',
        'version': '1.0.0',
      },
    };
  }

  @override
  DiceApiConfig parseConfig(Map<String, dynamic> params) =>
      DiceApiConfig.fromJson(params);
}

// === ROCK PAPER SCISSORS GENERATOR ===
class RpsApiConfig extends ApiConfig {
  final int quantity;

  RpsApiConfig({required this.quantity});

  factory RpsApiConfig.fromJson(Map<String, dynamic> json) {
    return RpsApiConfig(
      quantity: _parseInt(json['quantity']) ?? 10,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => {'quantity': quantity};

  @override
  bool isValid() => quantity > 0 && quantity <= 1000;
}

class RpsApiResult extends ApiResult {
  final List<String> results;
  final RpsApiConfig config;

  RpsApiResult({required this.results, required this.config});

  @override
  Map<String, dynamic> toJson() {
    return {
      'results': results,
      'count': results.length,
      'config': config.toJson(),
    };
  }
}

class RpsApiService implements ApiRandomGenerator<RpsApiConfig, RpsApiResult> {
  final Random _random = Random();
  static const List<String> _choices = ['Rock', 'Paper', 'Scissors'];

  @override
  String get generatorName => 'rps';

  @override
  String get description => 'Generate Rock, Paper, Scissors choices';

  @override
  String get version => '1.0.0';

  @override
  Future<RpsApiResult> generate(RpsApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for rps generator');
    }

    final results = List.generate(
      config.quantity,
      (index) => _choices[_random.nextInt(_choices.length)],
    );

    return RpsApiResult(results: results, config: config);
  }

  @override
  bool validateConfig(RpsApiConfig config) => config.isValid();

  @override
  RpsApiConfig getDefaultConfig() => RpsApiConfig(quantity: 10);

  @override
  Map<String, dynamic> resultToJson(RpsApiResult result) {
    return {
      'data': result.results, // Chỉ array kết quả
      'metadata': {
        'count': result.results.length,
        'config': result.config.toJson(),
        'generator': 'rps',
        'version': '1.0.0',
      },
    };
  }

  @override
  RpsApiConfig parseConfig(Map<String, dynamic> params) =>
      RpsApiConfig.fromJson(params);
}

// === YES/NO GENERATOR ===
class YesNoApiConfig extends ApiConfig {
  final int quantity;

  YesNoApiConfig({required this.quantity});

  factory YesNoApiConfig.fromJson(Map<String, dynamic> json) {
    return YesNoApiConfig(
      quantity: _parseInt(json['quantity']) ?? 10,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => {'quantity': quantity};

  @override
  bool isValid() => quantity > 0 && quantity <= 1000;
}

class YesNoApiResult extends ApiResult {
  final List<String> results;
  final YesNoApiConfig config;

  YesNoApiResult({required this.results, required this.config});

  @override
  Map<String, dynamic> toJson() {
    return {
      'results': results,
      'count': results.length,
      'config': config.toJson(),
    };
  }
}

class YesNoApiService
    implements ApiRandomGenerator<YesNoApiConfig, YesNoApiResult> {
  final Random _random = Random();
  static const List<String> _choices = ['Yes', 'No'];

  @override
  String get generatorName => 'yesno';

  @override
  String get description => 'Generate Yes or No answers';

  @override
  String get version => '1.0.0';

  @override
  Future<YesNoApiResult> generate(YesNoApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for yesno generator');
    }

    final results = List.generate(
      config.quantity,
      (index) => _choices[_random.nextInt(_choices.length)],
    );

    return YesNoApiResult(results: results, config: config);
  }

  @override
  bool validateConfig(YesNoApiConfig config) => config.isValid();

  @override
  YesNoApiConfig getDefaultConfig() => YesNoApiConfig(quantity: 10);

  @override
  Map<String, dynamic> resultToJson(YesNoApiResult result) {
    return {
      'data': result.results, // Chỉ array kết quả
      'metadata': {
        'count': result.results.length,
        'config': result.config.toJson(),
        'generator': 'yesno',
        'version': '1.0.0',
      },
    };
  }

  @override
  YesNoApiConfig parseConfig(Map<String, dynamic> params) =>
      YesNoApiConfig.fromJson(params);
}
