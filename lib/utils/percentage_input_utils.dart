import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text input formatter that limits percentage values to 0-100 range
class PercentageInputFormatter extends TextInputFormatter {
  final double minValue;
  final double maxValue;
  final int? decimalPlaces;

  const PercentageInputFormatter({
    this.minValue = 0.0,
    this.maxValue = 100.0,
    this.decimalPlaces,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Allow only numbers and decimal point
    final filteredText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Check for multiple decimal points
    final decimalMatches = '.'.allMatches(filteredText);
    if (decimalMatches.length > 1) {
      return oldValue;
    }

    // Parse the number
    final numValue = double.tryParse(filteredText);
    if (numValue == null) {
      return oldValue;
    }

    // Check min/max bounds
    if (numValue < minValue || numValue > maxValue) {
      return oldValue;
    }

    // Limit decimal places if specified
    String finalText = filteredText;
    if (decimalPlaces != null && filteredText.contains('.')) {
      final parts = filteredText.split('.');
      if (parts.length == 2 && parts[1].length > decimalPlaces!) {
        finalText = '${parts[0]}.${parts[1].substring(0, decimalPlaces!)}';
      }
    }

    return TextEditingValue(
      text: finalText,
      selection: TextSelection.collapsed(offset: finalText.length),
    );
  }
}

/// Utility methods for percentage input handling
class PercentageInputUtils {
  /// Validates and constrains a percentage value to the given range
  static String constrainPercentageValue(
    String value, {
    double minValue = 0.0,
    double maxValue = 100.0,
  }) {
    if (value.isEmpty) return value;

    final numValue = double.tryParse(value);
    if (numValue == null) return value;

    if (numValue < minValue) return minValue.toString();
    if (numValue > maxValue) return maxValue.toString();

    return value;
  }

  /// Creates an onChanged callback for percentage text fields
  static void Function(String) createPercentageOnChanged(
    TextEditingController controller, {
    double minValue = 0.0,
    double maxValue = 100.0,
  }) {
    return (value) {
      if (value.isNotEmpty) {
        final numValue = double.tryParse(value);
        if (numValue != null) {
          if (numValue > maxValue) {
            controller.text = maxValue.toString();
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
          } else if (numValue < minValue) {
            controller.text = minValue.toString();
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
          }
        }
      }
    };
  }
}
