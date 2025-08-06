import 'package:flutter/material.dart';

/// Generic icon widget that can display different types of icons
class GenericIcon extends StatelessWidget {
  final Widget _iconWidget;

  const GenericIcon._(this._iconWidget);

  /// Create from Material icon
  factory GenericIcon.icon(
    IconData icon, {
    double size = 24,
    Color? color,
  }) {
    return GenericIcon._(
      Icon(icon, size: size, color: color),
    );
  }

  /// Create from emoji
  factory GenericIcon.emoji(
    String emoji, {
    double size = 24,
    Color? color,
  }) {
    return GenericIcon._(
      EmojiIcon(emoji: emoji, size: size, color: color),
    );
  }

  /// Create from custom widget
  factory GenericIcon.widget(Widget widget) {
    return GenericIcon._(widget);
  }

  /// Create from icon data with builder pattern
  static GenericIcon fromIcon(IconData icon) => GenericIcon.icon(icon);
  static GenericIcon fromEmoji(String emoji) => GenericIcon.emoji(emoji);
  static GenericIcon fromWidget(Widget widget) => GenericIcon.widget(widget);

  @override
  Widget build(BuildContext context) => _iconWidget;
}

class EmojiIcon extends StatelessWidget {
  final String emoji;
  final Color? color;
  final double size;

  const EmojiIcon({
    super.key,
    required this.emoji,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: null, // Use system default emoji font
      ),
    );
  }
}

// Extension to create an IconData-like behavior for emojis
extension EmojiIconData on String {
  Widget toEmojiIcon({Color? color, double size = 24}) {
    return EmojiIcon(
      emoji: this,
      color: color,
      size: size,
    );
  }
}
