import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';
import 'package:faker/faker.dart';

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
  final faker = Faker();

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
      String result = '';

      if (config.type == 'words') {
        List<String> words = [];

        // Add "Lorem ipsum..." start if enabled
        if (config.startLorem) {
          words.addAll(['Lorem', 'ipsum', 'dolor', 'sit', 'amet']);
          // Generate remaining words
          if (config.quantity > 5) {
            for (int i = 0; i < config.quantity - 5; i++) {
              words.add(faker.lorem.word());
            }
          }
        } else {
          // Generate all words randomly
          for (int i = 0; i < config.quantity; i++) {
            words.add(faker.lorem.word());
          }
        }

        result = words.join(' ');
      } else if (config.type == 'sentences') {
        List<String> sentences = [];

        if (config.startLorem) {
          sentences
              .add('Lorem ipsum dolor sit amet, consectetur adipiscing elit.');
          // Generate remaining sentences
          if (config.quantity > 1) {
            for (int i = 0; i < config.quantity - 1; i++) {
              sentences.add(faker.lorem.sentence());
            }
          }
        } else {
          // Generate all sentences randomly
          for (int i = 0; i < config.quantity; i++) {
            sentences.add(faker.lorem.sentence());
          }
        }

        result = sentences.join(' ');
      } else {
        // Paragraphs
        List<String> paragraphs = [];

        if (config.startLorem) {
          paragraphs.add(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.');
          // Generate remaining paragraphs
          if (config.quantity > 1) {
            for (int i = 0; i < config.quantity - 1; i++) {
              paragraphs.add(faker.lorem
                  .sentences(3 + faker.randomGenerator.integer(4))
                  .join(' '));
            }
          }
        } else {
          // Generate all paragraphs randomly
          for (int i = 0; i < config.quantity; i++) {
            paragraphs.add(faker.lorem
                .sentences(3 + faker.randomGenerator.integer(4))
                .join(' '));
          }
        }

        result = paragraphs.join('\n\n');
      }

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
