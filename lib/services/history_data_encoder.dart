/// Utility class for encoding and decoding history data
/// Handles special characters and provides consistent data structure
class HistoryDataEncoder {
  // Special characters that need encoding
  static const String _separator = '|'; // Main separator between items
  static const String _escapeChar = '\\'; // Escape character
  static const String _encodedSeparator = '\\|'; // Encoded separator
  static const String _encodedEscape = '\\\\'; // Encoded escape
  static const String _encodedComma = '\\,'; // Encoded comma
  static const String _encodedSemicolon = '\\;'; // Encoded semicolon
  static const String _encodedNewline = '\\n'; // Encoded newline
  static const String _encodedQuote = '\\"'; // Encoded quote
  static const String _encodedApostrophe = "\\'"; // Encoded apostrophe
  static const String _encodedParentheses = '\\('; // Encoded parentheses
  static const String _encodedParenthesesClose =
      '\\)'; // Encoded parentheses close
  static const String _encodedBrackets = '\\['; // Encoded brackets
  static const String _encodedBracketsClose = '\\]'; // Encoded brackets close
  static const String _encodedBraces = '\\{'; // Encoded braces
  static const String _encodedBracesClose = '\\}'; // Encoded braces close

  /// Encodes a list of strings into a single encoded string
  /// Each item is properly escaped to handle special characters
  static String encodeList(List<String> items) {
    if (items.isEmpty) return '';

    final encodedItems = items.map((item) => _encodeItem(item)).toList();
    return encodedItems.join(_separator);
  }

  /// Decodes an encoded string back to a list of strings
  static List<String> decodeList(String encodedString) {
    if (encodedString.isEmpty) return [];

    // Check if this looks like a valid encoded string
    // Valid encoded strings should contain our separator or be a single item
    if (!encodedString.contains(_separator) &&
        !_isValidSingleItem(encodedString)) {
      throw FormatException('Invalid encoded string format');
    }

    final items = <String>[];
    final buffer = StringBuffer();
    bool escaped = false;

    for (int i = 0; i < encodedString.length; i++) {
      final char = encodedString[i];

      if (escaped) {
        buffer.write(_decodeEscapedChar(char));
        escaped = false;
      } else if (char == _escapeChar) {
        escaped = true;
      } else if (char == _separator) {
        items.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    // Add the last item
    if (buffer.isNotEmpty) {
      items.add(buffer.toString());
    }

    return items;
  }

  /// Checks if a string is a valid single item (no separators, properly escaped)
  static bool _isValidSingleItem(String str) {
    // A valid single item should not contain unescaped separators
    // and should either be empty or contain some encoded characters
    if (str.isEmpty) return true;

    bool escaped = false;
    bool hasEncodedChars = false;

    for (int i = 0; i < str.length; i++) {
      if (escaped) {
        escaped = false;
        hasEncodedChars = true; // Found an escape sequence
      } else if (str[i] == _escapeChar) {
        escaped = true;
      } else if (str[i] == _separator) {
        return false; // Found unescaped separator
      }
    }

    // If it's a single item, it should either be empty or have some encoded characters
    // or be a simple string without special characters
    return hasEncodedChars || _isSimpleString(str);
  }

  /// Checks if a string is a simple string without special characters
  static bool _isSimpleString(String str) {
    // Simple strings don't contain our special characters
    return !str.contains(_separator) &&
        !str.contains(_escapeChar) &&
        !str.contains(',') &&
        !str.contains(';') &&
        !str.contains('"') &&
        !str.contains("'") &&
        !str.contains('(') &&
        !str.contains(')') &&
        !str.contains('[') &&
        !str.contains(']') &&
        !str.contains('{') &&
        !str.contains('}') &&
        !str.contains('\n');
  }

  /// Encodes a single item by escaping special characters
  static String _encodeItem(String item) {
    return item
        .replaceAll(_escapeChar, _encodedEscape)
        .replaceAll(_separator, _encodedSeparator)
        .replaceAll(',', _encodedComma)
        .replaceAll(';', _encodedSemicolon)
        .replaceAll('\n', _encodedNewline)
        .replaceAll('"', _encodedQuote)
        .replaceAll("'", _encodedApostrophe)
        .replaceAll('(', _encodedParentheses)
        .replaceAll(')', _encodedParenthesesClose)
        .replaceAll('[', _encodedBrackets)
        .replaceAll(']', _encodedBracketsClose)
        .replaceAll('{', _encodedBraces)
        .replaceAll('}', _encodedBracesClose);
  }

  /// Decodes an escaped character
  static String _decodeEscapedChar(String char) {
    switch (char) {
      case '|':
        return _separator;
      case '\\':
        return _escapeChar;
      case ',':
        return ',';
      case ';':
        return ';';
      case 'n':
        return '\n';
      case '"':
        return '"';
      case "'":
        return "'";
      case '(':
        return '(';
      case ')':
        return ')';
      case '[':
        return '[';
      case ']':
        return ']';
      case '{':
        return '{';
      case '}':
        return '}';
      default:
        return char; // Return as-is if not a recognized escape sequence
    }
  }

  /// Validates that a string can be properly decoded
  static bool isValidEncodedString(String encodedString) {
    if (encodedString.isEmpty)
      return true; // Empty string is valid (empty list)

    // Check if this looks like our encoded format
    // Our encoded strings should either:
    // 1. Contain our separator '|'
    // 2. Be a simple string without special characters
    // 3. Contain escape sequences (backslash followed by special chars)
    if (encodedString.contains(_separator)) {
      return true; // Contains our separator, likely encoded
    }

    // Check for escape sequences
    if (encodedString.contains(_escapeChar)) {
      return true; // Contains escape sequences, likely encoded
    }

    // Check if it's a simple string (no special characters)
    if (_isSimpleString(encodedString)) {
      return true; // Simple string without special characters
    }

    // If it contains special characters but no escaping, it's likely not our format
    return false;
  }

  /// Gets a preview of decoded items (useful for debugging)
  static List<String> getPreview(String encodedString, {int maxItems = 5}) {
    try {
      final items = decodeList(encodedString);
      return items.take(maxItems).toList();
    } catch (e) {
      return ['Error decoding: $e'];
    }
  }
}

/// Extension methods for easier usage
extension HistoryDataEncoderExtension on List<String> {
  /// Encodes this list of strings
  String toEncodedHistory() => HistoryDataEncoder.encodeList(this);
}

extension HistoryDataDecoderExtension on String {
  /// Decodes this encoded string to a list
  List<String> fromEncodedHistory() => HistoryDataEncoder.decodeList(this);

  /// Checks if this string is valid encoded history
  bool get isValidEncodedHistory =>
      HistoryDataEncoder.isValidEncodedString(this);
}
