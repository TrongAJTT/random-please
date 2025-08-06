import 'package:flutter/foundation.dart';

enum DimensionType {
  fixed,
  percentage,
  flex,
  expanded,
}

/// A class to define dynamic dimensions for UI elements.
/// It supports fixed values, percentage-based values, and flexible values
/// with a maximum constraint.
@immutable
class DynamicDimension {
  final DimensionType type;
  final double value;
  final double? maxValue;
  final double? minValue;

  const DynamicDimension._(this.type, this.value,
      {this.maxValue, this.minValue});

  /// Creates a fixed dimension with a specific value.
  /// The [value] must be greater than 0.
  factory DynamicDimension.fix(double value) {
    if (value <= 0) {
      throw ArgumentError.value(value, 'value', 'Must be greater than 0');
    }
    return DynamicDimension._(DimensionType.fixed, value);
  }

  /// Creates a flexible dimension based on a percentage of available space,
  /// but constrained by a maximum value and a minimum value if provided.
  ///
  /// The [percentage] must be between 0 (exclusive) and 100 (inclusive).
  /// The [maxValue] must be greater than 0.
  factory DynamicDimension.flexibility(double percentage, double maxValue,
      {double? minValue}) {
    if (percentage <= 0 || percentage > 100) {
      throw ArgumentError.value(
          percentage, 'percentage', 'Must be between 0 and 100');
    }
    if (maxValue <= 0) {
      throw ArgumentError.value(maxValue, 'maxValue', 'Must be greater than 0');
    }
    if (minValue != null) {
      if (minValue <= 0) {
        throw ArgumentError.value(
            minValue, 'minValue', 'Must be greater than 0');
      }
      if (minValue > maxValue) {
        throw ArgumentError.value(
            minValue, 'minValue', 'Must be less than maxValue');
      }
    }
    return DynamicDimension._(DimensionType.flex, percentage / 100,
        maxValue: maxValue, minValue: minValue);
  }

  /// Creates a dimension based on a percentage of available space.
  /// The [percentage] must be between 0 (exclusive) and 100 (inclusive).
  factory DynamicDimension.percentage(double percentage) {
    if (percentage <= 0 || percentage > 100) {
      throw ArgumentError.value(
          percentage, 'percentage', 'Must be between 0 and 100');
    }
    return DynamicDimension._(DimensionType.percentage, percentage / 100);
  }

  /// Creates an expanded dimension that takes up all available space.
  factory DynamicDimension.expanded() {
    return const DynamicDimension._(DimensionType.expanded, 1);
  }

  /// Calculates the actual size based on the total available size.
  double calculate(double totalSize) {
    switch (type) {
      case DimensionType.fixed:
        return value;
      case DimensionType.percentage:
        return totalSize * value;
      case DimensionType.flex:
        final calculated = totalSize * value;
        if (maxValue != null && calculated > maxValue!) {
          return maxValue!;
        }
        if (minValue != null && calculated < minValue!) {
          return minValue!;
        }
        return calculated;
      case DimensionType.expanded:
        return totalSize;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DynamicDimension &&
        other.type == type &&
        other.value == value &&
        other.maxValue == maxValue &&
        other.minValue == minValue;
  }

  @override
  int get hashCode =>
      type.hashCode ^ value.hashCode ^ maxValue.hashCode ^ minValue.hashCode;
}
