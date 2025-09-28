import 'dart:math';
import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';

// Configuration cho Password Generator API theo CustomAPI.md
class PasswordApiConfig extends ApiConfig {
  final int quantity;
  final bool lower;
  final bool upper;
  final bool number;
  final bool special;

  PasswordApiConfig({
    required this.quantity,
    required this.lower,
    required this.upper,
    required this.number,
    required this.special,
  });

  factory PasswordApiConfig.fromJson(Map<String, dynamic> json) {
    return PasswordApiConfig(
      quantity: _parseInt(json['quantity']) ?? 8,
      lower: _parseBool(json['lower']) ?? true,
      upper: _parseBool(json['upper']) ?? true,
      number: _parseBool(json['number']) ?? true,
      special: _parseBool(json['special']) ?? true,
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
      'quantity': quantity,
      'lower': lower,
      'upper': upper,
      'number': number,
      'special': special,
    };
  }

  @override
  bool isValid() {
    return quantity > 0 &&
        quantity <= 256 &&
        (lower || upper || number || special);
  }
}

// Result cho Password Generator API
class PasswordApiResult extends ApiResult {
  final String password;
  final PasswordApiConfig config;

  PasswordApiResult({
    required this.password,
    required this.config,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'length': password.length,
      'config': config.toJson(),
    };
  }
}

// Password Generator API Service
class PasswordApiService
    implements ApiRandomGenerator<PasswordApiConfig, PasswordApiResult> {
  final Random _random = Random();

  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  @override
  String get generatorName => 'password';

  @override
  String get description =>
      'Generate secure random passwords with customizable character sets';

  @override
  String get version => '1.0.0';

  @override
  Future<PasswordApiResult> generate(PasswordApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for password generator');
    }

    String charset = '';
    if (config.lower) charset += _lowercase;
    if (config.upper) charset += _uppercase;
    if (config.number) charset += _numbers;
    if (config.special) charset += _special;

    final password = List.generate(
      config.quantity,
      (index) => charset[_random.nextInt(charset.length)],
    ).join();

    return PasswordApiResult(
      password: password,
      config: config,
    );
  }

  @override
  bool validateConfig(PasswordApiConfig config) {
    return config.isValid();
  }

  @override
  PasswordApiConfig getDefaultConfig() {
    return PasswordApiConfig(
      quantity: 8,
      lower: true,
      upper: true,
      number: true,
      special: true,
    );
  }

  @override
  Map<String, dynamic> resultToJson(PasswordApiResult result) {
    return {
      'data': result.password, // Chỉ password string
      'metadata': {
        'length': result.password.length,
        'config': result.config.toJson(),
        'generator': generatorName,
        'version': version,
      },
    };
  }

  @override
  PasswordApiConfig parseConfig(Map<String, dynamic> params) {
    return PasswordApiConfig.fromJson(params);
  }
}
