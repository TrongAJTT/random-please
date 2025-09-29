import 'dart:math';

/// Cryptographically secure random utilities
/// ONLY use for security-critical purposes: passwords, tokens, keys, salts
/// Uses Random.secure() which gets entropy directly from the OS
class SecureRandomUtils {
  SecureRandomUtils._();

  static final Random _secureRandom = Random.secure();

  /// Generate cryptographically secure password
  /// Uses Random.secure() to ensure unpredictability
  static String generatePassword({
    required int length,
    required bool includeLowercase,
    required bool includeUppercase,
    required bool includeNumbers,
    required bool includeSpecial,
  }) {
    if (length <= 0) {
      throw ArgumentError('Password length must be positive');
    }

    // At least one category must be selected
    if (!includeLowercase &&
        !includeUppercase &&
        !includeNumbers &&
        !includeSpecial) {
      throw ArgumentError('At least one character set must be selected');
    }

    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const special = '!@#\$%^&*()-_=+[]{}|;:,.<>?/';

    // Build character set and required characters
    String allowedChars = '';
    List<String> requiredChars = [];

    if (includeLowercase) {
      allowedChars += lowercase;
      requiredChars.add(lowercase[_secureRandom.nextInt(lowercase.length)]);
    }
    if (includeUppercase) {
      allowedChars += uppercase;
      requiredChars.add(uppercase[_secureRandom.nextInt(uppercase.length)]);
    }
    if (includeNumbers) {
      allowedChars += numbers;
      requiredChars.add(numbers[_secureRandom.nextInt(numbers.length)]);
    }
    if (includeSpecial) {
      allowedChars += special;
      requiredChars.add(special[_secureRandom.nextInt(special.length)]);
    }

    if (length < requiredChars.length) {
      throw ArgumentError(
          'Password length must be at least ${requiredChars.length} for selected character sets');
    }

    final List<String> passwordChars = [...requiredChars];

    // Fill remaining positions with random characters
    for (int i = requiredChars.length; i < length; i++) {
      final randomIndex = _secureRandom.nextInt(allowedChars.length);
      passwordChars.add(allowedChars[randomIndex]);
    }

    // Shuffle the password characters to randomize positions
    for (int i = passwordChars.length - 1; i > 0; i--) {
      final j = _secureRandom.nextInt(i + 1);
      final temp = passwordChars[i];
      passwordChars[i] = passwordChars[j];
      passwordChars[j] = temp;
    }

    return passwordChars.join();
  }

  /// Generate cryptographically secure token/key
  /// Returns hex string of specified length
  static String generateSecureToken(int length) {
    if (length <= 0) {
      throw ArgumentError('Token length must be positive');
    }

    const hexChars = '0123456789abcdef';
    final StringBuffer token = StringBuffer();

    for (int i = 0; i < length; i++) {
      final randomIndex = _secureRandom.nextInt(hexChars.length);
      token.write(hexChars[randomIndex]);
    }

    return token.toString();
  }

  /// Generate cryptographically secure bytes
  /// Useful for keys, salts, IVs
  static List<int> generateSecureBytes(int count) {
    if (count <= 0) {
      throw ArgumentError('Byte count must be positive');
    }

    final bytes = <int>[];
    for (int i = 0; i < count; i++) {
      bytes.add(_secureRandom.nextInt(256)); // 0-255
    }

    return bytes;
  }

  /// Generate cryptographically secure integer in range [0, max)
  /// Use for security-critical random selections
  static int nextSecureInt(int max) {
    if (max <= 0) {
      throw ArgumentError('Max must be positive');
    }

    return _secureRandom.nextInt(max);
  }

  /// Generate cryptographically secure double in range [0.0, 1.0)
  /// Use for security-critical random probabilities
  static double nextSecureDouble() {
    return _secureRandom.nextDouble();
  }

  /// Generate cryptographically secure boolean
  /// Use for security-critical random decisions
  static bool nextSecureBool() {
    return _secureRandom.nextBool();
  }
}
