/// Utility class for masking sensitive string data
///
/// Provides various methods to mask characters in strings while preserving
/// formatting and special characters. Useful for hiding sensitive information
/// like device IDs, passwords, or other identifiers in UI.
///
/// Example usage:
/// ```dart
/// // Mask only digits: "ABC-123-DEF" -> "ABC-***-DEF"
/// String masked = StringMaskUtils.maskDigits("ABC-123-DEF");
///
/// // Mask letters and digits: "ABC-123-DEF" -> "***-***-***"
/// String masked = StringMaskUtils.maskAlphanumeric("ABC-123-DEF");
///
/// // Create preview: "very-long-device-id" -> "ve**********id"
/// String preview = StringMaskUtils.createPreview("very-long-device-id");
/// ```
class StringMaskUtils {
  /// Mask characters in a string based on the specified pattern
  ///
  /// [input] - The string to mask
  /// [maskDigits] - Whether to mask digits (0-9)
  /// [maskLetters] - Whether to mask letters (a-z, A-Z)
  /// [maskChar] - The character to use for masking (default: '*')
  /// [preserveSpecialChars] - Whether to preserve special characters like hyphens, dots, etc.
  static String maskString(
    String input, {
    bool maskDigits = true,
    bool maskLetters = false,
    String maskChar = '*',
    bool preserveSpecialChars = true,
  }) {
    if (input.isEmpty) return input;

    return input.replaceAllMapped(RegExp(r'.'), (match) {
      final char = match.group(0)!;

      // Check if it's a digit
      if (maskDigits && RegExp(r'\d').hasMatch(char)) {
        return maskChar;
      }

      // Check if it's a letter
      if (maskLetters && RegExp(r'[a-zA-Z]').hasMatch(char)) {
        return maskChar;
      }

      // If preserveSpecialChars is false, mask everything else except whitespace
      if (!preserveSpecialChars && !RegExp(r'\s').hasMatch(char)) {
        return maskChar;
      }

      // Return original character (for special chars, whitespace, etc.)
      return char;
    });
  }

  /// Mask only digits in a string (legacy method for backward compatibility)
  static String maskDigits(String input, {String maskChar = '*'}) {
    return maskString(input,
        maskDigits: true, maskLetters: false, maskChar: maskChar);
  }

  /// Mask only letters in a string
  static String maskLetters(String input, {String maskChar = '*'}) {
    return maskString(input,
        maskDigits: false, maskLetters: true, maskChar: maskChar);
  }

  /// Mask both digits and letters, preserving special characters
  static String maskAlphanumeric(String input, {String maskChar = '*'}) {
    return maskString(input,
        maskDigits: true, maskLetters: true, maskChar: maskChar);
  }

  /// Mask everything except whitespace
  static String maskAll(String input, {String maskChar = '*'}) {
    return maskString(
      input,
      maskDigits: true,
      maskLetters: true,
      maskChar: maskChar,
      preserveSpecialChars: false,
    );
  }

  /// Create a preview of masked string (show first and last few characters)
  static String createPreview(
    String input, {
    int visibleStart = 2,
    int visibleEnd = 2,
    String maskChar = '*',
    int minMaskLength = 3,
  }) {
    if (input.length <= visibleStart + visibleEnd + minMaskLength) {
      return maskAlphanumeric(input, maskChar: maskChar);
    }

    final start = input.substring(0, visibleStart);
    final end = input.substring(input.length - visibleEnd);
    final maskLength = input.length - visibleStart - visibleEnd;
    final mask = maskChar * maskLength;

    return '$start$mask$end';
  }
}
