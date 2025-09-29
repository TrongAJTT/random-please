import 'package:flutter_test/flutter_test.dart';
import 'package:random_please/utils/standard_random_utils.dart';
import 'package:random_please/utils/secure_random_utils.dart';

void main() {
  group('StandardRandomUtils - Distribution Quality Tests', () {
    test('nextInt produces uniform distribution', () {
      const sampleSize = 10000;
      const min = 1;
      const max = 6; // Like a dice
      final buckets = <int, int>{};

      // Initialize buckets
      for (int i = min; i <= max; i++) {
        buckets[i] = 0;
      }

      // Generate samples
      for (int i = 0; i < sampleSize; i++) {
        final value = StandardRandomUtils.nextInt(min, max);
        buckets[value] = buckets[value]! + 1;
      }

      // Each value should appear roughly 1/6 of the time (≈1667 times)
      // Allow ±10% tolerance for statistical variation
      const expectedFreq = sampleSize / (max - min + 1);
      const tolerance = expectedFreq * 0.1;

      for (int i = min; i <= max; i++) {
        final freq = buckets[i]!;
        expect(freq, closeTo(expectedFreq, tolerance),
            reason:
                'Value $i appeared $freq times, expected $expectedFreq ± $tolerance');
      }
    });

    test('nextDouble produces uniform distribution', () {
      const sampleSize = 10000;
      final samples = <double>[];

      // Generate samples in [0.0, 1.0]
      for (int i = 0; i < sampleSize; i++) {
        samples.add(StandardRandomUtils.nextDouble());
      }

      // Check mean is close to 0.5
      final mean = samples.reduce((a, b) => a + b) / samples.length;
      expect(mean, closeTo(0.5, 0.05), reason: 'Mean should be close to 0.5');

      // Check all values are in range [0.0, 1.0)
      expect(samples.every((x) => x >= 0.0 && x < 1.0), true);

      // Check distribution across quartiles
      final q1 = samples.where((x) => x < 0.25).length;
      final q2 = samples.where((x) => x >= 0.25 && x < 0.5).length;
      final q3 = samples.where((x) => x >= 0.5 && x < 0.75).length;
      final q4 = samples.where((x) => x >= 0.75).length;

      const expectedPerQuartile = sampleSize / 4;
      const tolerance = expectedPerQuartile * 0.1;

      expect(q1, closeTo(expectedPerQuartile, tolerance));
      expect(q2, closeTo(expectedPerQuartile, tolerance));
      expect(q3, closeTo(expectedPerQuartile, tolerance));
      expect(q4, closeTo(expectedPerQuartile, tolerance));
    });

    test('shuffle produces truly random permutations', () {
      final original = [1, 2, 3, 4, 5];
      const trials = 1000;
      var identicalCount = 0;

      for (int i = 0; i < trials; i++) {
        final shuffled = StandardRandomUtils.shuffle(original);

        // Check length preserved
        expect(shuffled.length, original.length);

        // Check all elements present
        for (final element in original) {
          expect(shuffled.contains(element), true);
        }

        // Count how many times shuffle result is identical to original
        bool identical = true;
        for (int j = 0; j < original.length; j++) {
          if (shuffled[j] != original[j]) {
            identical = false;
            break;
          }
        }
        if (identical) identicalCount++;
      }

      // Probability of identical result is 1/5! = 1/120 ≈ 0.83%
      // With 1000 trials, expect around 8-9 identical results
      // Allow range 0-20 for statistical variation
      expect(identicalCount, lessThan(20),
          reason: 'Too many identical shuffles suggest poor randomness');
    });

    test('pickUniqueRandom never returns duplicates', () {
      final items = List.generate(100, (i) => i);

      for (int count = 1; count <= 50; count += 5) {
        final selected = StandardRandomUtils.pickUniqueRandom(items, count);

        expect(selected.length, count);
        expect(selected.toSet().length, count,
            reason: 'Selected items must be unique');

        // All selected items must be from original list
        for (final item in selected) {
          expect(items.contains(item), true);
        }
      }
    });

    test('splitIntoTeams distributes items evenly', () {
      final items = List.generate(20, (i) => 'Player${i + 1}');

      final teams = StandardRandomUtils.splitIntoTeams(items, 4);

      expect(teams.length, 4);

      // All players should be assigned
      final allPlayersAssigned = teams.expand((team) => team).toList();
      expect(allPlayersAssigned.length, items.length);

      // No player should be on multiple teams
      expect(allPlayersAssigned.toSet().length, items.length);

      // Teams should be balanced (within 1 player difference)
      final teamSizes = teams.map((team) => team.length).toList();
      final minSize = teamSizes.reduce((a, b) => a < b ? a : b);
      final maxSize = teamSizes.reduce((a, b) => a > b ? a : b);
      expect(maxSize - minSize, lessThanOrEqualTo(1));
    });

    test('rollDice produces expected results', () {
      const trials = 6000; // 1000 per face
      const sides = 6;
      final buckets = <int, int>{};

      // Initialize buckets (1-6 for standard dice)
      for (int i = 1; i <= sides; i++) {
        buckets[i] = 0;
      }

      // Roll single die many times
      for (int i = 0; i < trials; i++) {
        final rolls = StandardRandomUtils.rollDice(1, sides);
        expect(rolls.length, 1);
        final value = rolls[0];
        expect(value, greaterThanOrEqualTo(1));
        expect(value, lessThanOrEqualTo(sides));
        buckets[value] = buckets[value]! + 1;
      }

      // Check distribution
      const expectedFreq = trials / sides;
      const tolerance = expectedFreq * 0.1;

      for (int i = 1; i <= sides; i++) {
        final freq = buckets[i]!;
        expect(freq, closeTo(expectedFreq, tolerance),
            reason:
                'Face $i appeared $freq times, expected $expectedFreq ± $tolerance');
      }
    });
  });

  group('SecureRandomUtils - Security Tests', () {
    test('generatePassword produces cryptographically secure passwords', () {
      const trials = 100;
      final passwords = <String>{};

      for (int i = 0; i < trials; i++) {
        final password = SecureRandomUtils.generatePassword(
          length: 16,
          includeLowercase: true,
          includeUppercase: true,
          includeNumbers: true,
          includeSpecial: true,
        );

        expect(password.length, 16);
        passwords.add(password);

        // Check character variety
        expect(password, matches(r'[a-z]'), reason: 'Must contain lowercase');
        expect(password, matches(r'[A-Z]'), reason: 'Must contain uppercase');
        expect(password, matches(r'[0-9]'), reason: 'Must contain numbers');
        expect(password, matches(r'[!@#\$%^&*()\-_=+\[\]{}|;:,.<>?/]'),
            reason: 'Must contain special characters');
      }

      // All passwords should be unique (extremely high probability)
      expect(passwords.length, trials,
          reason: 'Secure passwords should never repeat');
    });

    test('generateSecureToken produces unique tokens', () {
      const trials = 1000;
      final tokens = <String>{};

      for (int i = 0; i < trials; i++) {
        final token = SecureRandomUtils.generateSecureToken(32);

        expect(token.length, 32);
        expect(token, matches(r'^[0-9a-f]+$'), reason: 'Must be valid hex');
        tokens.add(token);
      }

      // All tokens should be unique
      expect(tokens.length, trials,
          reason: 'Secure tokens should never repeat');
    });

    test('nextSecureInt is properly bounded', () {
      const trials = 1000;
      const max = 10;

      for (int i = 0; i < trials; i++) {
        final value = SecureRandomUtils.nextSecureInt(max);
        expect(value, greaterThanOrEqualTo(0));
        expect(value, lessThan(max));
      }
    });

    test('nextSecureDouble is properly bounded', () {
      const trials = 1000;

      for (int i = 0; i < trials; i++) {
        final value = SecureRandomUtils.nextSecureDouble();
        expect(value, greaterThanOrEqualTo(0.0));
        expect(value, lessThan(1.0));
      }
    });

    test('generateSecureBytes produces expected length', () {
      for (int length = 1; length <= 100; length += 10) {
        final bytes = SecureRandomUtils.generateSecureBytes(length);

        expect(bytes.length, length);

        // All bytes should be valid (0-255)
        for (final byte in bytes) {
          expect(byte, greaterThanOrEqualTo(0));
          expect(byte, lessThanOrEqualTo(255));
        }
      }
    });
  });

  group('Error Handling Tests', () {
    test('StandardRandomUtils handles invalid inputs gracefully', () {
      expect(() => StandardRandomUtils.nextInt(10, 5), throwsArgumentError);
      expect(
          () => StandardRandomUtils.nextDouble(1.0, 0.0), throwsArgumentError);
      expect(() => StandardRandomUtils.pickRandom([]), throwsArgumentError);
      expect(() => StandardRandomUtils.rollDice(0, 6), throwsArgumentError);
      expect(() => StandardRandomUtils.rollDice(1, 0), throwsArgumentError);
    });

    test('SecureRandomUtils handles invalid inputs gracefully', () {
      expect(
          () => SecureRandomUtils.generatePassword(
                length: 0,
                includeLowercase: true,
                includeUppercase: false,
                includeNumbers: false,
                includeSpecial: false,
              ),
          throwsArgumentError);

      expect(
          () => SecureRandomUtils.generatePassword(
                length: 10,
                includeLowercase: false,
                includeUppercase: false,
                includeNumbers: false,
                includeSpecial: false,
              ),
          throwsArgumentError);

      expect(
          () => SecureRandomUtils.generateSecureToken(0), throwsArgumentError);
      expect(
          () => SecureRandomUtils.generateSecureBytes(0), throwsArgumentError);
      expect(() => SecureRandomUtils.nextSecureInt(0), throwsArgumentError);
    });
  });
}
