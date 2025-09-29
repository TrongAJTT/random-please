import 'dart:math';
import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';

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
  final Random _random = Random();

  static const List<String> _suits = ['Hearts', 'Diamonds', 'Clubs', 'Spades'];
  static const List<String> _ranks = [
    'A',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'J',
    'Q',
    'K'
  ];

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

    // Create deck
    List<PlayingCard> deck = [];

    // Add standard cards
    for (final suit in _suits) {
      for (final rank in _ranks) {
        deck.add(PlayingCard(
          suit: suit,
          rank: rank,
          name: '$rank of $suit',
        ));
      }
    }

    // Add jokers if requested
    if (config.joker) {
      deck.add(PlayingCard(
        suit: '',
        rank: 'Joker',
        name: 'Red Joker',
        isJoker: true,
      ));
      deck.add(PlayingCard(
        suit: '',
        rank: 'Joker',
        name: 'Black Joker',
        isJoker: true,
      ));
    }

    List<PlayingCard> result = [];
    List<PlayingCard> availableCards = List.from(deck);

    for (int i = 0; i < config.quantity; i++) {
      if (availableCards.isEmpty) break;

      final index = _random.nextInt(availableCards.length);
      final card = availableCards[index];
      result.add(card);

      if (!config.allowDuplicates) {
        availableCards.removeAt(index);
      }
    }

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
