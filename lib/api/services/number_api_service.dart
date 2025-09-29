import '../../models/random_generator.dart';
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

    final numbers = RandomGenerator.generateNumbers(
      isInteger: config.type == 'int',
      min: config.from,
      max: config.to,
      count: config.quantity,
      allowDuplicates: config.allowDuplicates,
    );

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
