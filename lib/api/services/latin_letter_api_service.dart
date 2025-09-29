import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';
import '../../models/random_generator.dart';

// Latin Letter Generator API Service theo CustomAPI.md spec
// Endpoint: /api/v1/random/letter
// Parameters: quantity, lower, upper, dup

class LatinLetterApiConfig extends ApiConfig {
  final int quantity;
  final bool lower; // Include lowercase letters
  final bool upper; // Include uppercase letters
  final bool dup; // Allow duplicates

  LatinLetterApiConfig({
    required this.quantity,
    required this.lower,
    required this.upper,
    required this.dup,
  });

  factory LatinLetterApiConfig.fromJson(Map<String, dynamic> json) {
    return LatinLetterApiConfig(
      quantity: _parseInt(json['quantity']) ?? 10,
      lower: _parseBool(json['lower']) ?? true,
      upper: _parseBool(json['upper']) ?? true,
      dup: _parseBool(json['dup']) ?? true,
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
    if (value is int) {
      return value != 0;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'lower': lower,
        'upper': upper,
        'dup': dup,
      };

  @override
  bool isValid() {
    if (quantity <= 0 || quantity > 1000) return false;
    if (!lower && !upper) return false; // At least one case must be selected

    // Check if unique letters are possible when dup=false
    if (!dup) {
      int availableLetters = 0;
      if (lower) availableLetters += 26; // a-z
      if (upper) availableLetters += 26; // A-Z
      if (quantity > availableLetters) return false;
    }

    return true;
  }
}

class LatinLetterApiResult extends ApiResult {
  final String letters;
  final LatinLetterApiConfig config;

  LatinLetterApiResult({required this.letters, required this.config});

  @override
  Map<String, dynamic> toJson() {
    return {
      'letters': letters,
      'count': letters.length,
      'config': config.toJson(),
    };
  }
}

class LatinLetterApiService
    implements ApiRandomGenerator<LatinLetterApiConfig, LatinLetterApiResult> {
  @override
  String get generatorName => 'letter';

  @override
  String get description =>
      'Generate random Latin letters with customizable cases and duplicates';

  @override
  String get version => '1.0.0';

  @override
  LatinLetterApiConfig parseConfig(Map<String, dynamic> json) {
    return LatinLetterApiConfig.fromJson(json);
  }

  @override
  Future<LatinLetterApiResult> generate(LatinLetterApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for latin letter generator');
    }

    try {
      final letters = RandomGenerator.generateLatinLetters(
        config.quantity,
        includeUppercase: config.upper,
        includeLowercase: config.lower,
        allowDuplicates: config.dup,
      );

      return LatinLetterApiResult(letters: letters, config: config);
    } catch (e) {
      throw ArgumentError('Failed to generate letters: ${e.toString()}');
    }
  }

  @override
  bool validateConfig(LatinLetterApiConfig config) {
    return config.isValid();
  }

  @override
  LatinLetterApiConfig getDefaultConfig() {
    return LatinLetterApiConfig(
      quantity: 10,
      lower: true,
      upper: true,
      dup: true,
    );
  }

  @override
  Map<String, dynamic> resultToJson(LatinLetterApiResult result) {
    return {
      'data': result.letters,
      'metadata': {
        'count': result.letters.length,
        'config': result.config.toJson(),
        'generator': generatorName,
        'version': version,
      },
    };
  }
}
