import 'package:flutter/material.dart';
import '../utils/secure_random_utils.dart';
import '../utils/standard_random_utils.dart';

/// Playing card representation
class PlayingCard {
  final String suit;
  final String rank;

  PlayingCard({required this.suit, required this.rank});

  @override
  String toString() => '$rank$suit';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayingCard &&
          runtimeType == other.runtimeType &&
          suit == other.suit &&
          rank == other.rank;

  @override
  int get hashCode => suit.hashCode ^ rank.hashCode;

  bool get isRed => suit == '♥' || suit == '♦';
}

/// Utility class for all random generation functionality
/// Completely rewritten to use proper statistical algorithms
///
/// SECURITY NOTE:
/// - Password generation uses Random.secure() for cryptographic security
/// - All other functions use dart:math Random() for optimal performance and quality
class RandomGenerator {
  RandomGenerator._(); // Private constructor - static class

  /// Generate cryptographically secure password
  /// Uses Random.secure() - NEVER use for non-security purposes due to performance
  static String generatePassword({
    required int length,
    required bool includeLowercase,
    required bool includeUppercase,
    required bool includeNumbers,
    required bool includeSpecial,
  }) {
    return SecureRandomUtils.generatePassword(
      length: length,
      includeLowercase: includeLowercase,
      includeUppercase: includeUppercase,
      includeNumbers: includeNumbers,
      includeSpecial: includeSpecial,
    );
  }

  /// Generate random numbers with proper uniform distribution
  /// Uses standard Random() for optimal performance and quality
  static List<num> generateNumbers({
    required bool isInteger,
    required num min,
    required num max,
    required int count,
    required bool allowDuplicates,
  }) {
    if (min > max) {
      throw ArgumentError(
          'Minimum value must be less than or equal to maximum value');
    }

    if (count <= 0) {
      return [];
    }

    // Validate unique number generation
    if (!allowDuplicates && isInteger) {
      final possibleValues = (max.toInt() - min.toInt() + 1);
      if (count > possibleValues) {
        throw ArgumentError(
            'Cannot generate $count unique integers in range $min to $max');
      }
    }

    final List<num> numbers = [];

    if (allowDuplicates) {
      // Simple case - allow duplicates
      for (int i = 0; i < count; i++) {
        if (isInteger) {
          numbers.add(StandardRandomUtils.nextInt(min.toInt(), max.toInt()));
        } else {
          final value =
              StandardRandomUtils.nextDouble(min.toDouble(), max.toDouble());
          numbers.add(double.parse(value.toStringAsFixed(2)));
        }
      }
    } else {
      // Complex case - ensure uniqueness
      if (isInteger) {
        // For integers, generate all possible values and pick unique subset
        final allValues = List.generate(
          max.toInt() - min.toInt() + 1,
          (index) => min.toInt() + index,
        );
        numbers.addAll(StandardRandomUtils.pickUniqueRandom(allValues, count));
      } else {
        // For floats, keep generating until we have enough unique values
        final uniqueNumbers = <num>{};
        while (uniqueNumbers.length < count) {
          final value =
              StandardRandomUtils.nextDouble(min.toDouble(), max.toDouble());
          uniqueNumbers.add(double.parse(value.toStringAsFixed(2)));
        }
        numbers.addAll(uniqueNumbers);
      }
    }

    return numbers;
  }

  /// Generate Yes/No with proper 50/50 probability
  static bool generateYesNo() {
    return StandardRandomUtils.nextBool();
  }

  /// Generate coin flip with proper 50/50 probability
  static bool generateCoinFlip() {
    return StandardRandomUtils.nextBool(); // true = heads, false = tails
  }

  /// Generate Rock-Paper-Scissors with proper uniform distribution
  static int generateRockPaperScissors() {
    return StandardRandomUtils.nextInt(0, 2); // 0: Rock, 1: Paper, 2: Scissors
  }

  /// Generate dice rolls with proper uniform distribution
  static List<int> generateDiceRolls({required int count, required int sides}) {
    if (count <= 0) {
      return [];
    }

    if (sides <= 0) {
      throw ArgumentError('Dice must have at least 1 side');
    }

    return StandardRandomUtils.rollDice(count, sides);
  }

  /// Generate color with proper uniform distribution across RGB space
  static Color generateColor({bool withAlpha = false}) {
    final r = StandardRandomUtils.nextInt(0, 255);
    final g = StandardRandomUtils.nextInt(0, 255);
    final b = StandardRandomUtils.nextInt(0, 255);
    final a = withAlpha ? StandardRandomUtils.nextInt(0, 255) : 255;

    return Color.fromARGB(a, r, g, b);
  }

  /// Generate Latin letters with proper uniform distribution
  static String generateLatinLetters(
    int count, {
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool allowDuplicates = true,
  }) {
    if (count <= 0) {
      return '';
    }

    const String lowers = 'abcdefghijklmnopqrstuvwxyz';
    const String uppers = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    String availableLetters = '';
    if (includeLowercase) availableLetters += lowers;
    if (includeUppercase) availableLetters += uppers;

    if (availableLetters.isEmpty) {
      throw ArgumentError('At least one letter case must be included');
    }

    if (!allowDuplicates && count > availableLetters.length) {
      throw ArgumentError(
          'Cannot generate $count unique letters from available set');
    }

    final letterList = availableLetters.split('');

    if (allowDuplicates) {
      return StandardRandomUtils.pickRandomMultiple(letterList, count).join('');
    } else {
      return StandardRandomUtils.pickUniqueRandom(letterList, count).join('');
    }
  }

  /// Generate playing cards with proper uniform distribution
  static List<PlayingCard> generatePlayingCards({
    required int count,
    required bool includeJokers,
    required bool allowDuplicates,
  }) {
    if (count <= 0) {
      return [];
    }

    // Create standard deck
    final List<PlayingCard> deck = [];
    final suits = ['♠', '♥', '♦', '♣'];
    final ranks = [
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

    for (final suit in suits) {
      for (final rank in ranks) {
        deck.add(PlayingCard(suit: suit, rank: rank));
      }
    }

    // Add jokers if requested
    if (includeJokers) {
      deck.add(PlayingCard(suit: '🃏', rank: 'Joker'));
      deck.add(PlayingCard(suit: '🃏', rank: 'Joker'));
    }

    // Validate unique card generation
    if (!allowDuplicates && count > deck.length) {
      throw ArgumentError(
          'Cannot generate $count unique cards. Only ${deck.length} cards available.');
    }

    if (allowDuplicates) {
      return StandardRandomUtils.pickRandomMultiple(deck, count);
    } else {
      return StandardRandomUtils.pickUniqueRandom(deck, count);
    }
  }

  /// Generate random dates with proper uniform distribution
  static List<DateTime> generateRandomDates({
    required DateTime startDate,
    required DateTime endDate,
    required int count,
    required bool allowDuplicates,
  }) {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date must be before end date');
    }

    if (count <= 0) {
      return [];
    }

    final int totalDays = endDate.difference(startDate).inDays + 1;

    // Validate unique date generation
    if (!allowDuplicates && count > totalDays) {
      throw ArgumentError('Cannot generate $count unique dates in range');
    }

    if (allowDuplicates) {
      final dates = <DateTime>[];
      for (int i = 0; i < count; i++) {
        final daysToAdd = StandardRandomUtils.nextInt(0, totalDays - 1);
        dates.add(startDate.add(Duration(days: daysToAdd)));
      }
      return dates;
    } else {
      // Generate unique day offsets
      final dayOffsets = List.generate(totalDays, (index) => index);
      final selectedOffsets =
          StandardRandomUtils.pickUniqueRandom(dayOffsets, count);

      return selectedOffsets
          .map((offset) => startDate.add(Duration(days: offset)))
          .toList();
    }
  }

  /// Generate random times with proper uniform distribution
  static List<TimeOfDay> generateRandomTimes({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int count,
    required bool allowDuplicates,
  }) {
    // Convert to minutes for easier calculation
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;

    // Handle cross-midnight case
    if (endMinutes <= startMinutes) {
      endMinutes += 24 * 60; // Add 24 hours
    }

    final totalMinutes = endMinutes - startMinutes + 1;

    // Validate unique time generation
    if (!allowDuplicates && count > totalMinutes) {
      throw ArgumentError('Cannot generate $count unique times in range');
    }

    if (allowDuplicates) {
      final times = <TimeOfDay>[];
      for (int i = 0; i < count; i++) {
        final randomMinutes = StandardRandomUtils.nextInt(0, totalMinutes - 1);
        final actualMinutes = (startMinutes + randomMinutes) % (24 * 60);
        times.add(TimeOfDay(
          hour: actualMinutes ~/ 60,
          minute: actualMinutes % 60,
        ));
      }
      return times;
    } else {
      // Generate unique minute offsets
      final minuteOffsets = List.generate(totalMinutes, (index) => index);
      final selectedOffsets =
          StandardRandomUtils.pickUniqueRandom(minuteOffsets, count);

      return selectedOffsets.map((offset) {
        final actualMinutes = (startMinutes + offset) % (24 * 60);
        return TimeOfDay(
          hour: actualMinutes ~/ 60,
          minute: actualMinutes % 60,
        );
      }).toList();
    }
  }

  /// Pick random items from list (utility function)
  static List<T> pickRandomItems<T>(List<T> items, {required int quantity}) {
    return StandardRandomUtils.pickRandomMultiple(items, quantity);
  }

  /// Shuffle and take items (utility function)
  static List<T> shuffleTake<T>(List<T> items, {required int quantity}) {
    return StandardRandomUtils.pickUniqueRandom(items, quantity);
  }

  /// Split into teams (utility function)
  static List<List<T>> splitIntoTeams<T>(List<T> items, {required int teams}) {
    return StandardRandomUtils.splitIntoTeams(items, teams);
  }

  /// Generate Lorem Ipsum text
  static String generateLorem({
    required String type,
    required int count,
    required bool startWithLorem,
  }) {
    // Lorem ipsum word bank
    const words = [
      'lorem',
      'ipsum',
      'dolor',
      'sit',
      'amet',
      'consectetur',
      'adipiscing',
      'elit',
      'sed',
      'do',
      'eiusmod',
      'tempor',
      'incididunt',
      'ut',
      'labore',
      'et',
      'dolore',
      'magna',
      'aliqua',
      'enim',
      'ad',
      'minim',
      'veniam',
      'quis',
      'nostrud',
      'exercitation',
      'ullamco',
      'laboris',
      'nisi',
      'aliquip',
      'ex',
      'ea',
      'commodo',
      'consequat',
      'duis',
      'aute',
      'irure',
      'in',
      'reprehenderit',
      'voluptate',
      'velit',
      'esse',
      'cillum',
      'fugiat',
      'nulla',
      'pariatur',
      'excepteur',
      'sint',
      'occaecat',
      'cupidatat',
      'non',
      'proident',
      'sunt',
      'culpa',
      'qui',
      'officia',
      'deserunt',
      'mollit',
      'anim',
      'id',
      'est',
      'laborum'
    ];

    switch (type.toLowerCase()) {
      case 'words':
        final selectedWords = <String>[];
        if (startWithLorem) {
          selectedWords.addAll(['Lorem', 'ipsum']);
          for (int i = 2; i < count; i++) {
            selectedWords.add(StandardRandomUtils.pickRandom(words));
          }
        } else {
          for (int i = 0; i < count; i++) {
            selectedWords.add(StandardRandomUtils.pickRandom(words));
          }
        }
        return '${selectedWords.join(' ')}.';

      case 'sentences':
        final sentences = <String>[];
        for (int i = 0; i < count; i++) {
          final wordsInSentence = StandardRandomUtils.nextInt(8, 15);
          final sentenceWords = <String>[];

          if (i == 0 && startWithLorem) {
            sentenceWords.addAll(['Lorem', 'ipsum']);
            for (int j = 2; j < wordsInSentence; j++) {
              sentenceWords.add(StandardRandomUtils.pickRandom(words));
            }
          } else {
            for (int j = 0; j < wordsInSentence; j++) {
              sentenceWords.add(StandardRandomUtils.pickRandom(words));
            }
          }

          // Capitalize first word
          if (sentenceWords.isNotEmpty) {
            sentenceWords[0] =
                '${sentenceWords[0][0].toUpperCase()}${sentenceWords[0].substring(1)}';
          }

          sentences.add('${sentenceWords.join(' ')}.');
        }
        return sentences.join(' ');

      case 'paragraphs':
        final paragraphs = <String>[];
        for (int i = 0; i < count; i++) {
          final sentencesInParagraph = StandardRandomUtils.nextInt(3, 7);
          final paragraphSentences = <String>[];

          for (int j = 0; j < sentencesInParagraph; j++) {
            final wordsInSentence = StandardRandomUtils.nextInt(8, 15);
            final sentenceWords = <String>[];

            if (i == 0 && j == 0 && startWithLorem) {
              sentenceWords.addAll(['Lorem', 'ipsum']);
              for (int k = 2; k < wordsInSentence; k++) {
                sentenceWords.add(StandardRandomUtils.pickRandom(words));
              }
            } else {
              for (int k = 0; k < wordsInSentence; k++) {
                sentenceWords.add(StandardRandomUtils.pickRandom(words));
              }
            }

            // Capitalize first word
            if (sentenceWords.isNotEmpty) {
              sentenceWords[0] =
                  '${sentenceWords[0][0].toUpperCase()}${sentenceWords[0].substring(1)}';
            }

            paragraphSentences.add('${sentenceWords.join(' ')}.');
          }

          paragraphs.add(paragraphSentences.join(' '));
        }
        return paragraphs.join('\n\n');

      default:
        throw ArgumentError(
            'Invalid type: $type. Use "words", "sentences", or "paragraphs".');
    }
  }
}
