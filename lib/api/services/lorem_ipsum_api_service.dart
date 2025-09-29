import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';
import '../../models/random_generator.dart';

// Lorem Ipsum Generator API Service theo CustomAPI.md spec
// Endpoint: /api/v1/random/lorem
// Parameters: type, quantity, start_lorem

class LoremIpsumApiConfig extends ApiConfig {
  final String type; // 'words', 'sentences', 'paragraphs'
  final int quantity;
  final bool startLorem; // Start with "Lorem ipsum dolor sit amet..."

  LoremIpsumApiConfig({
    required this.type,
    required this.quantity,
    required this.startLorem,
  });

  factory LoremIpsumApiConfig.fromJson(Map<String, dynamic> json) {
    return LoremIpsumApiConfig(
      type: (json['type'] as String?) ?? 'sentences',
      quantity: _parseInt(json['quantity']) ?? 5,
      startLorem: _parseBool(json['start_lorem']) ?? true,
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
        'type': type,
        'quantity': quantity,
        'start_lorem': startLorem,
      };

  @override
  bool isValid() {
    if (quantity <= 0 || quantity > 1000) return false;
    if (!['words', 'sentences', 'paragraphs'].contains(type)) return false;
    return true;
  }
}

class LoremIpsumApiResult extends ApiResult {
  final String text;
  final LoremIpsumApiConfig config;

  LoremIpsumApiResult({required this.text, required this.config});

  @override
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': config.type,
      'quantity': config.quantity,
      'config': config.toJson(),
    };
  }
}

class LoremIpsumApiService
    implements ApiRandomGenerator<LoremIpsumApiConfig, LoremIpsumApiResult> {
  @override
  String get generatorName => 'lorem';

  @override
  String get description =>
      'Generate lorem ipsum text with customizable type and quantity';

  @override
  String get version => '1.0.0';

  @override
  LoremIpsumApiConfig parseConfig(Map<String, dynamic> json) {
    return LoremIpsumApiConfig.fromJson(json);
  }

  @override
  Future<LoremIpsumApiResult> generate(LoremIpsumApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for lorem ipsum generator');
    }

    try {
      final result = RandomGenerator.generateLorem(
        type: config.type,
        count: config.quantity,
        startWithLorem: config.startLorem,
      );

      return LoremIpsumApiResult(text: result, config: config);
    } catch (e) {
      throw ArgumentError('Failed to generate lorem ipsum: ${e.toString()}');
    }
  }

  @override
  bool validateConfig(LoremIpsumApiConfig config) {
    return config.isValid();
  }

  @override
  LoremIpsumApiConfig getDefaultConfig() {
    return LoremIpsumApiConfig(
      type: 'sentences',
      quantity: 5,
      startLorem: true,
    );
  }

  @override
  Map<String, dynamic> resultToJson(LoremIpsumApiResult result) {
    return {
      'data': result.text,
      'metadata': {
        'type': result.config.type,
        'quantity': result.config.quantity,
        'start_lorem': result.config.startLorem,
        'config': result.config.toJson(),
        'generator': generatorName,
        'version': version,
      },
    };
  }
}
