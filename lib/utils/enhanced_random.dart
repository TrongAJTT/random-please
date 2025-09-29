import 'dart:math';
import 'package:faker/faker.dart' show Faker;

/// Enhanced random utilities combining multiple entropy sources
/// - Faker random generator
/// - Dart Random
/// - Timestamp-seeded Random
class EnhancedRandom {
  EnhancedRandom._();

  static final Random _dartRandom = Random();
  static final Faker _faker = Faker();

  /// Returns [0, max) uniformly by mixing three sources
  static int nextInt(int max) {
    if (max <= 0) return 0;
    final fakerValue = _faker.randomGenerator.integer(max);
    final dartValue = _dartRandom.nextInt(max);
    final timestampSeed = DateTime.now().millisecondsSinceEpoch % 1000;
    final timestampRandom = Random(timestampSeed);
    final timestampValue = timestampRandom.nextInt(max);
    return (fakerValue + dartValue + timestampValue) % max;
  }

  /// Returns a double in [0, 1) by averaging three sources
  static double nextDouble() {
    final fakerValue = _faker.randomGenerator.decimal(scale: 1.0);
    final dartValue = _dartRandom.nextDouble();
    final timestampSeed = DateTime.now().millisecondsSinceEpoch % 1000;
    final timestampRandom = Random(timestampSeed);
    final timestampValue = timestampRandom.nextDouble();
    return (fakerValue + dartValue + timestampValue) / 3.0;
  }
}
