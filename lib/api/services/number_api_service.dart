import 'dart:math';
import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';

// Configuration cho Number Generator API theo CustomAPI.md
class NumberApiConfig extends ApiConfig {
  final double from;
  final double to;
  final int quantity;
  final String type; // 'int' or 'float'
  final bool allowDuplicates;

  NumberApiConfig({
    required this.from,
    required this.to,
    required this.quantity,
    required this.type,
    required this.allowDuplicates,
  });

  factory NumberApiConfig.fromJson(Map<String, dynamic> json) {
    return NumberApiConfig(
      from: _parseDouble(json['from']) ?? 1.0,
      to: _parseDouble(json['to']) ?? 100.0,
      quantity: _parseInt(json['quantity']) ?? 1,
      type: (json['type'] as String?) ?? 'int',
      allowDuplicates: _parseBool(json['dup']) ?? true,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'quantity': quantity,
      'type': type,
      'dup': allowDuplicates,
    };
  }

  @override
  bool isValid() {
    return from < to &&
        quantity > 0 &&
        quantity <= 1000 &&
        ['int', 'float'].contains(type);
  }
}

// Result cho Number Generator API
class NumberApiResult extends ApiResult {
  final List<num> numbers;
  final NumberApiConfig config;

  NumberApiResult({
    required this.numbers,
    required this.config,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'numbers': numbers,
      'count': numbers.length,
      'config': config.toJson(),
    };
  }
}

// Number Generator API Service
class NumberApiService
    implements ApiRandomGenerator<NumberApiConfig, NumberApiResult> {
  final Random _random = Random();

  @override
  String get generatorName => 'number';

  @override
  String get description =>
      'Generate random numbers with customizable range and options';

  @override
  String get version => '1.0.0';

  @override
  Future<NumberApiResult> generate(NumberApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for number generator');
    }

    final List<num> numbers = [];
    final Set<num> usedNumbers = <num>{};

    for (int i = 0; i < config.quantity; i++) {
      num value;
      int attempts = 0;
      const maxAttempts = 1000;

      do {
        if (config.type == 'int') {
          value = config.from.toInt() +
              _random.nextInt((config.to - config.from).toInt() + 1);
        } else {
          value =
              config.from + _random.nextDouble() * (config.to - config.from);
          // Round to 2 decimal places for doubles
          value = (value * 100).round() / 100;
        }
        attempts++;
      } while (!config.allowDuplicates &&
          usedNumbers.contains(value) &&
          attempts < maxAttempts);

      if (!config.allowDuplicates && attempts >= maxAttempts) {
        break; // Avoid infinite loop if range is too small
      }

      numbers.add(value);
      if (!config.allowDuplicates) {
        usedNumbers.add(value);
      }
    }

    return NumberApiResult(
      numbers: numbers,
      config: config,
    );
  }

  @override
  bool validateConfig(NumberApiConfig config) {
    return config.isValid();
  }

  @override
  NumberApiConfig getDefaultConfig() {
    return NumberApiConfig(
      from: 1.0,
      to: 100.0,
      quantity: 1,
      type: 'int',
      allowDuplicates: true,
    );
  }

  @override
  Map<String, dynamic> resultToJson(NumberApiResult result) {
    return {
      'data': result.numbers, // Chỉ data gọn gàng
      'metadata': {
        'count': result.numbers.length,
        'config': result.config.toJson(),
        'generator': generatorName,
        'version': version,
      },
    };
  }

  @override
  NumberApiConfig parseConfig(Map<String, dynamic> params) {
    return NumberApiConfig.fromJson(params);
  }
}
