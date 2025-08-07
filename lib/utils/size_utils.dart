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
  /// constrained by both a minimum and maximum value.
  ///
  /// The [percent] must be between 0 (exclusive) and 100 (inclusive).
  /// The [minValue] and [maxValue] must be greater than 0, and minValue <= maxValue.
  factory DynamicDimension.flexibility(
      double percent, double minValue, double maxValue) {
    if (percent <= 0 || percent > 100) {
      throw ArgumentError.value(
          percent, 'percent', 'Must be between 0 and 100');
    }
    if (minValue <= 0) {
      throw ArgumentError.value(minValue, 'minValue', 'Must be greater than 0');
    }
    if (maxValue <= 0) {
      throw ArgumentError.value(maxValue, 'maxValue', 'Must be greater than 0');
    }
    if (minValue > maxValue) {
      throw ArgumentError.value(
          minValue, 'minValue', 'Must be less than or equal to maxValue');
    }
    return DynamicDimension._(DimensionType.flex, percent / 100,
        minValue: minValue, maxValue: maxValue);
  }

  /// Creates a flexible dimension based on a percentage of available space,
  /// constrained by a minimum value.
  ///
  /// The [percent] must be between 0 (exclusive) and 100 (inclusive).
  /// The [minValue] must be greater than 0.
  factory DynamicDimension.flexibilityMin(double percent, double minValue) {
    if (percent <= 0 || percent > 100) {
      throw ArgumentError.value(
          percent, 'percent', 'Must be between 0 and 100');
    }
    if (minValue <= 0) {
      throw ArgumentError.value(minValue, 'minValue', 'Must be greater than 0');
    }
    return DynamicDimension._(DimensionType.flex, percent / 100,
        minValue: minValue);
  }

  /// Creates a flexible dimension based on a percentage of available space,
  /// constrained by a maximum value.
  ///
  /// The [percent] must be between 0 (exclusive) and 100 (inclusive).
  /// The [maxValue] must be greater than 0.
  factory DynamicDimension.flexibilityMax(double percent, double maxValue) {
    if (percent <= 0 || percent > 100) {
      throw ArgumentError.value(
          percent, 'percent', 'Must be between 0 and 100');
    }
    if (maxValue <= 0) {
      throw ArgumentError.value(maxValue, 'maxValue', 'Must be greater than 0');
    }
    return DynamicDimension._(DimensionType.flex, percent / 100,
        maxValue: maxValue);
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

@immutable
class TwoDimSpacing {
  final double verticalSpacing;
  final double horizontalSpacing;

  const TwoDimSpacing._(this.verticalSpacing, this.horizontalSpacing);

  /// Creates spacing with the same value for both vertical and horizontal.
  factory TwoDimSpacing.both(double spacing) {
    if (spacing < 0) {
      throw ArgumentError.value(spacing, 'spacing', 'Must be non-negative');
    }
    return TwoDimSpacing._(spacing, spacing);
  }

  /// Creates spacing with specific values for vertical and horizontal.
  factory TwoDimSpacing.specific({
    required double vertical,
    required double horizontal,
  }) {
    if (vertical < 0) {
      throw ArgumentError.value(vertical, 'vertical', 'Must be non-negative');
    }
    if (horizontal < 0) {
      throw ArgumentError.value(
          horizontal, 'horizontal', 'Must be non-negative');
    }
    return TwoDimSpacing._(vertical, horizontal);
  }

  /// Creates spacing with only one direction set, the other is zero.
  factory TwoDimSpacing.only({
    double vertical = 0,
    double horizontal = 0,
  }) {
    if (vertical < 0) {
      throw ArgumentError.value(vertical, 'vertical', 'Must be non-negative');
    }
    if (horizontal < 0) {
      throw ArgumentError.value(
          horizontal, 'horizontal', 'Must be non-negative');
    }
    return TwoDimSpacing._(vertical, horizontal);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwoDimSpacing &&
          runtimeType == other.runtimeType &&
          verticalSpacing == other.verticalSpacing &&
          horizontalSpacing == other.horizontalSpacing;

  @override
  int get hashCode => verticalSpacing.hashCode ^ horizontalSpacing.hashCode;
}
