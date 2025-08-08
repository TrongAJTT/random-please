import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Service to manage the order of tools in the UI
class ToolOrderService {
  static const String _toolOrderKey = 'tool_order';

  /// Default tool order (when no custom order is saved)
  static const List<String> _defaultToolOrder = [
    'password',
    'number',
    'yesno',
    'coin',
    'rps',
    'dice',
    'color',
    'letters',
    'cards',
    'date',
    'time',
    'datetime',
    'lorem'
  ];

  /// Get the current tool order from storage
  static Future<List<String>> getToolOrder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderJson = prefs.getStringList(_toolOrderKey);

      if (orderJson != null && orderJson.isNotEmpty) {
        // Validate that all default tools are present
        final savedOrder = orderJson.toList();
        final missingTools = _defaultToolOrder
            .where((tool) => !savedOrder.contains(tool))
            .toList();
        final extraTools = savedOrder
            .where((tool) => !_defaultToolOrder.contains(tool))
            .toList();

        // Remove extra tools and add missing tools at the end
        savedOrder.removeWhere((tool) => extraTools.contains(tool));
        savedOrder.addAll(missingTools);

        return savedOrder;
      }

      return _defaultToolOrder.toList();
    } catch (e) {
      return _defaultToolOrder.toList();
    }
  }

  /// Save the tool order to storage
  static Future<void> saveToolOrder(List<String> order) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_toolOrderKey, order);
    } catch (e) {
      // Ignore errors - will use default order
    }
  }

  /// Reset tool order to default
  static Future<void> resetToDefault() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_toolOrderKey);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Check if current order is different from default
  static Future<bool> isCustomOrder() async {
    final currentOrder = await getToolOrder();
    return !_listEquals(currentOrder, _defaultToolOrder);
  }

  /// Helper to compare two lists
  static bool _listEquals<T>(List<T> list1, List<T> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}

/// Represents a single tool item with all its properties
class ToolItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget Function(bool isEmbedded) screenBuilder;

  const ToolItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screenBuilder,
  });

  /// Create a copy of this tool item with different properties
  ToolItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? color,
    Widget Function(bool isEmbedded)? screenBuilder,
  }) {
    return ToolItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      screenBuilder: screenBuilder ?? this.screenBuilder,
    );
  }
}
