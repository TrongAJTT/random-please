import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';
import '../../models/random_generator.dart' as main_random;

// Configuration cho Playing Cards API theo CustomAPI.md
class CardsApiConfig extends ApiConfig {
  final int quantity;
  final bool joker;
  final bool allowDuplicates;

  CardsApiConfig({
    required this.quantity,
    required this.joker,
    required this.allowDuplicates,
  });

  factory CardsApiConfig.fromJson(Map<String, dynamic> json) {
    final parsedQuantity = _parseInt(json['quantity']) ?? 8;
    final parsedJoker =
        _parseBool(json['joker']) ?? _parseBool(json['includeJokers']) ?? true;
    final parsedDup =
        _parseBool(json['dup']) ?? _parseBool(json['allowDuplicates']) ?? true;

    return CardsApiConfig(
      quantity: parsedQuantity,
      joker: parsedJoker,
      allowDuplicates: parsedDup,
    );
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'joker': joker,
      'dup': allowDuplicates,
    };
  }

  @override
  bool isValid() {
    return quantity > 0 && quantity <= (joker ? 54 : 52);
  }
}

// Card data model
class PlayingCard {
  final String suit;
  final String rank;
  final String name;
  final bool isJoker;

  PlayingCard({
    required this.suit,
    required this.rank,
    required this.name,
    this.isJoker = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'suit': suit,
      'rank': rank,
      'name': name,
      'isJoker': isJoker,
    };
  }
}

// Result cho Playing Cards API
class CardsApiResult extends ApiResult {
  final List<PlayingCard> cards;
  final CardsApiConfig config;

  CardsApiResult({
    required this.cards,
    required this.config,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'cards': cards.map((c) => c.toJson()).toList(),
      'count': cards.length,
      'config': config.toJson(),
    };
  }
}

// Playing Cards API Service
class CardsApiService
    implements ApiRandomGenerator<CardsApiConfig, CardsApiResult> {
  // Deck composition is defined in the main RandomGenerator implementation

  @override
  String get generatorName => 'card';

  @override
  String get description =>
      'Generate random playing cards with optional jokers';

  @override
  String get version => '1.0.0';

  @override
  Future<CardsApiResult> generate(CardsApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for cards generator');
    }

    // Delegate to main RandomGenerator to get unified behavior
    final generated = main_random.RandomGenerator.generatePlayingCards(
      count: config.quantity,
      includeJokers: config.joker,
      allowDuplicates: config.allowDuplicates,
    );

    // Map main model to API model
    final result = generated
        .map((c) => PlayingCard(
              suit: c.suit,
              rank: c.rank,
              name: '${c.rank} of ${c.suit}',
              isJoker: c.rank == 'Joker',
            ))
        .toList();

    return CardsApiResult(
      cards: result,
      config: config,
    );
  }

  @override
  bool validateConfig(CardsApiConfig config) {
    return config.isValid();
  }

  @override
  CardsApiConfig getDefaultConfig() {
    return CardsApiConfig(
      quantity: 8,
      joker: true,
      allowDuplicates: true,
    );
  }

  @override
  Map<String, dynamic> resultToJson(CardsApiResult result) {
    return {
      'data':
          result.cards.map((c) => c.toJson()).toList(), // Chỉ danh sách cards
      'metadata': {
        'count': result.cards.length,
        'config': result.config.toJson(),
        'generator': generatorName,
        'version': version,
      },
    };
  }

  @override
  CardsApiConfig parseConfig(Map<String, dynamic> params) {
    return CardsApiConfig.fromJson(params);
  }
}
