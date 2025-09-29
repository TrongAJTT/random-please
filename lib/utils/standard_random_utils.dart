import 'dart:math';

/// Standard random utilities for general purposes
/// Uses dart:math Random() - high quality, fast, statistically sound
/// DO NOT use for security-critical purposes (passwords, tokens, keys)
/// Perfect for: games, simulations, UI effects, non-sensitive randomization
class StandardRandomUtils {
  StandardRandomUtils._();

  static final Random _random = Random();

  /// Generate random integer in range [min, max] (inclusive)
  /// Uses proper uniform distribution - no bias
  static int nextInt(int min, int max) {
    if (min > max) {
      throw ArgumentError('min cannot be greater than max');
    }

    if (min == max) return min;

    // Proper uniform distribution: [min, max] inclusive
    return min + _random.nextInt(max - min + 1);
  }

  /// Generate random double in range [min, max]
  /// Uses proper uniform distribution
  static double nextDouble([double min = 0.0, double max = 1.0]) {
    if (min > max) {
      throw ArgumentError('min cannot be greater than max');
    }

    if (min == max) return min;

    // Proper uniform distribution in range
    return min + _random.nextDouble() * (max - min);
  }

  /// Generate random boolean
  /// 50/50 probability, properly uniform
  static bool nextBool() {
    return _random.nextBool();
  }

  /// Pick random element from list
  /// Properly uniform selection
  static T pickRandom<T>(List<T> items) {
    if (items.isEmpty) {
      throw ArgumentError('Cannot pick from empty list');
    }

    return items[_random.nextInt(items.length)];
  }

  /// Pick multiple random elements (with replacement)
  /// Each pick is independent and uniform
  static List<T> pickRandomMultiple<T>(List<T> items, int count) {
    if (items.isEmpty) {
      throw ArgumentError('Cannot pick from empty list');
    }

    if (count <= 0) return [];

    final results = <T>[];
    for (int i = 0; i < count; i++) {
      results.add(items[_random.nextInt(items.length)]);
    }

    return results;
  }

  /// Pick unique random elements (without replacement)
  /// Uses Fisher-Yates algorithm for proper uniform distribution
  static List<T> pickUniqueRandom<T>(List<T> items, int count) {
    if (items.isEmpty) {
      throw ArgumentError('Cannot pick from empty list');
    }

    if (count <= 0) return [];

    if (count >= items.length) {
      // Return shuffled copy of all items
      return shuffle(List.from(items));
    }

    // Fisher-Yates partial shuffle - only select what we need
    final workingList = List<T>.from(items);
    final results = <T>[];

    for (int i = 0; i < count; i++) {
      final randomIndex = i + _random.nextInt(workingList.length - i);

      // Swap current position with random position
      final temp = workingList[i];
      workingList[i] = workingList[randomIndex];
      workingList[randomIndex] = temp;

      results.add(workingList[i]);
    }

    return results;
  }

  /// Shuffle list using Fisher-Yates algorithm
  /// Properly uniform shuffle - no bias
  static List<T> shuffle<T>(List<T> items) {
    if (items.length <= 1) return List.from(items);

    final shuffled = List<T>.from(items);

    // Fisher-Yates shuffle
    for (int i = shuffled.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);

      // Swap elements
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }

    return shuffled;
  }

  /// Split list into random teams
  /// First shuffles, then distributes evenly
  static List<List<T>> splitIntoTeams<T>(List<T> items, int teamCount) {
    if (items.isEmpty || teamCount <= 0) {
      return [];
    }

    if (teamCount >= items.length) {
      // Each item gets its own team
      return items.map((item) => [item]).toList();
    }

    final shuffledItems = shuffle(items);
    final teams = List.generate(teamCount, (index) => <T>[]);

    // Distribute items round-robin style
    for (int i = 0; i < shuffledItems.length; i++) {
      teams[i % teamCount].add(shuffledItems[i]);
    }

    return teams;
  }

  /// Generate dice roll results
  /// Properly uniform distribution for each die
  static List<int> rollDice(int diceCount, int sides) {
    if (diceCount <= 0 || sides <= 0) {
      throw ArgumentError('Dice count and sides must be positive');
    }

    final results = <int>[];
    for (int i = 0; i < diceCount; i++) {
      results.add(1 + _random.nextInt(sides)); // 1 to sides inclusive
    }

    return results;
  }

  /// Generate random integers for color components (0-255)
  /// Properly uniform distribution across color space
  static int nextColorComponent() {
    return _random.nextInt(256); // 0-255
  }
}
