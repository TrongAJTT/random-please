import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class NumberFormatService {
  static NumberFormat? _numberFormat;
  static String? _currentLocale;

  /// Initialize the number formatter with the current locale
  static void initialize(Locale locale) {
    final localeString = locale.toString();

    if (_currentLocale != localeString) {
      _currentLocale = localeString;

      try {
        // Create number format for the specific locale
        _numberFormat = NumberFormat.decimalPattern(localeString);
      } catch (e) {
        // Fallback to default locale if specific locale is not supported
        _numberFormat = NumberFormat.decimalPattern();
      }
    }
  }

  /// Format a number with locale-specific thousands separators and decimal points
  static String formatNumber(double value, {int? decimalPlaces}) {
    if (_numberFormat == null) {
      // Fallback to default formatting if not initialized
      return value.toString();
    }

    // Handle special cases
    if (value.isNaN) return 'NaN';
    if (value.isInfinite) return value.isNegative ? '-∞' : '∞';
    if (value == 0) return '0';

    try {
      if (decimalPlaces != null) {
        // Set specific decimal places
        _numberFormat!.minimumFractionDigits = 0;
        _numberFormat!.maximumFractionDigits = decimalPlaces;
        return _numberFormat!.format(value);
      } else {
        // Smart formatting based on value magnitude
        return _formatWithSmartPrecision(value);
      }
    } catch (e) {
      // Fallback to basic formatting
      return value.toString();
    }
  }

  /// Format with smart precision based on value magnitude
  static String _formatWithSmartPrecision(double value) {
    final absValue = value.abs();

    if (absValue == absValue.toInt()) {
      // Integer values
      _numberFormat!.minimumFractionDigits = 0;
      _numberFormat!.maximumFractionDigits = 0;
      return _numberFormat!.format(value);
    } else if (absValue >= 1000000000) {
      // Very large values: use exponential notation
      return value.toStringAsExponential(6);
    } else if (absValue >= 1000000) {
      // Large values: show 2-4 decimal places max
      _numberFormat!.minimumFractionDigits = 0;
      _numberFormat!.maximumFractionDigits = 4;
      final formatted = _numberFormat!.format(value);
      return _removeTrailingZeros(formatted);
    } else if (absValue >= 1000) {
      // Medium values: show 2-6 decimal places max
      _numberFormat!.minimumFractionDigits = 0;
      _numberFormat!.maximumFractionDigits = 6;
      final formatted = _numberFormat!.format(value);
      return _removeTrailingZeros(formatted);
    } else if (absValue >= 1) {
      // Values >= 1: show up to 8 decimal places
      _numberFormat!.minimumFractionDigits = 0;
      _numberFormat!.maximumFractionDigits = 8;
      final formatted = _numberFormat!.format(value);
      return _removeTrailingZeros(formatted);
    } else if (absValue >= 0.0001) {
      // Small values: show up to 10 decimal places for high precision
      _numberFormat!.minimumFractionDigits = 0;
      _numberFormat!.maximumFractionDigits = 10;
      final formatted = _numberFormat!.format(value);
      return _removeTrailingZeros(formatted);
    } else if (absValue > 0) {
      // Very small values: use exponential notation with high precision
      return value.toStringAsExponential(8);
    } else {
      return '0';
    }
  }

  /// Remove trailing zeros after decimal point while preserving locale formatting
  static String _removeTrailingZeros(String formatted) {
    if (!formatted.contains(_getDecimalSeparator())) {
      return formatted;
    }

    final decimalSeparator = _getDecimalSeparator();
    final parts = formatted.split(decimalSeparator);
    if (parts.length != 2) return formatted;

    final wholePart = parts[0];
    final decimalPart = parts[1].replaceAll(RegExp(r'0+$'), '');

    if (decimalPart.isEmpty) {
      return wholePart;
    } else {
      return '$wholePart$decimalSeparator$decimalPart';
    }
  }

  /// Get the decimal separator for the current locale
  static String _getDecimalSeparator() {
    if (_numberFormat == null) return '.';
    return _numberFormat!.symbols.DECIMAL_SEP;
  }

  /// Format currency values with appropriate precision
  static String formatCurrency(double value) {
    if (_numberFormat == null) {
      return value.toStringAsFixed(2);
    }

    try {
      if (value >= 1000000) {
        // Large amounts: show in millions
        final millions = value / 1000000;
        _numberFormat!.minimumFractionDigits = 0;
        _numberFormat!.maximumFractionDigits = 2;
        return '${_numberFormat!.format(millions)}M';
      } else if (value >= 1000) {
        // Medium amounts: show in thousands
        final thousands = value / 1000;
        _numberFormat!.minimumFractionDigits = 0;
        _numberFormat!.maximumFractionDigits = 2;
        return '${_numberFormat!.format(thousands)}K';
      } else {
        // Regular amounts: show with 2 decimal places
        _numberFormat!.minimumFractionDigits = 2;
        _numberFormat!.maximumFractionDigits = 2;
        return _numberFormat!.format(value);
      }
    } catch (e) {
      return value.toStringAsFixed(2);
    }
  }

  /// Format length/mass/other unit values with high precision
  static String formatUnit(double value) {
    return formatNumber(value);
  }

  /// Format percentage values
  static String formatPercentage(double value, {int decimalPlaces = 2}) {
    return formatNumber(value, decimalPlaces: decimalPlaces);
  }

  /// Get sample format for different locales (for testing/preview)
  static Map<String, String> getSampleFormats(double value) {
    final samples = <String, String>{};

    // Vietnamese format
    try {
      final vnFormat = NumberFormat.decimalPattern('vi_VN');
      samples['vi'] = vnFormat.format(value);
    } catch (e) {
      samples['vi'] = value.toString();
    }

    // English format
    try {
      final enFormat = NumberFormat.decimalPattern('en_US');
      samples['en'] = enFormat.format(value);
    } catch (e) {
      samples['en'] = value.toString();
    }

    return samples;
  }
}
