import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utility class for formatting numbers with locale-specific formatting
class NumberFormatter {
  /// Format an integer with locale-specific thousand separators
  static String formatInteger(int number, Locale locale) {
    final formatter = NumberFormat.decimalPattern(locale.toString());
    return formatter.format(number);
  }

  /// Format a double with locale-specific thousand separators and decimal places
  static String formatDouble(double number, Locale locale,
      {int? decimalPlaces}) {
    final formatter = NumberFormat.decimalPattern(locale.toString());

    if (decimalPlaces != null) {
      formatter.minimumFractionDigits = decimalPlaces;
      formatter.maximumFractionDigits = decimalPlaces;
    }

    return formatter.format(number);
  }

  /// Format a number (int or double) with locale-specific formatting
  static String formatNumber(num number, Locale locale,
      {bool isInteger = false, int? decimalPlaces}) {
    if (isInteger || number is int) {
      return formatInteger(number.toInt(), locale);
    } else {
      return formatDouble(number.toDouble(), locale,
          decimalPlaces: decimalPlaces ?? 2);
    }
  }

  /// Format a range of numbers for display (e.g., "1,000 - 10,000")
  static String formatRange(num min, num max, Locale locale,
      {bool isInteger = false, int? decimalPlaces}) {
    final formattedMin = formatNumber(min, locale,
        isInteger: isInteger, decimalPlaces: decimalPlaces);
    final formattedMax = formatNumber(max, locale,
        isInteger: isInteger, decimalPlaces: decimalPlaces);
    return '$formattedMin - $formattedMax';
  }

  /// Get the current locale from context
  static Locale getCurrentLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }
}
