import 'package:flutter_test/flutter_test.dart';
import 'package:random_please/models/random_generator.dart';

void main() {
  group('RandomGenerator numbers', () {
    test('generates correct count with integers', () {
      final result = RandomGenerator.generateNumbers(
        isInteger: true,
        min: 1,
        max: 10,
        count: 5,
        allowDuplicates: true,
      );
      expect(result.length, 5);
      expect(result.every((e) => e is int && e >= 1 && e <= 10), true);
    });
  });

  group('RandomGenerator color', () {
    test('generates color without alpha', () {
      final c = RandomGenerator.generateColor(withAlpha: false);
      expect(c.alpha, 0xFF);
    });
  });

  group('RandomGenerator cards', () {
    test('generates requested count with duplicates allowed', () {
      final cards = RandomGenerator.generatePlayingCards(
        count: 5,
        includeJokers: false,
        allowDuplicates: true,
      );
      expect(cards.length, 5);
    });
  });

  group('RandomGenerator dates', () {
    test('generates within range', () {
      final start = DateTime(2024, 1, 1);
      final end = DateTime(2024, 12, 31);
      final dates = RandomGenerator.generateRandomDates(
        startDate: start,
        endDate: end,
        count: 3,
        allowDuplicates: true,
      );
      expect(dates.length, 3);
      expect(dates.every((d) => !d.isBefore(start) && !d.isAfter(end)), true);
    });
  });

  group('RandomGenerator letters', () {
    test('respects count', () {
      final s = RandomGenerator.generateLatinLetters(8,
          includeUppercase: true,
          includeLowercase: true,
          allowDuplicates: true);
      expect(s.length, 8);
    });
  });

  group('RandomGenerator list helpers', () {
    test('random pick < length', () {
      final items = ['a', 'b', 'c', 'd', 'e'];
      final out = RandomGenerator.pickRandomItems(items, quantity: 2);
      expect(out.length, 2);
    });

    test('shuffle take <= length', () {
      final items = ['a', 'b', 'c'];
      final out = RandomGenerator.shuffleTake(items, quantity: 3);
      expect(out.length, 3);
    });

    test('split into teams produces labels', () {
      final items = ['a', 'b', 'c', 'd'];
      final out = RandomGenerator.splitIntoTeams(items, teams: 2);
      expect(out.length, 2);
      expect(out.first.startsWith('Team '), true);
    });
  });

  group('RandomGenerator lorem', () {
    test('sentences with lorem start', () {
      final text = RandomGenerator.generateLorem(
        type: 'sentences',
        quantity: 2,
        startLorem: true,
      );
      expect(text.contains('Lorem ipsum'), true);
    });
  });
}
