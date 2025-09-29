import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';
import '../../models/random_generator.dart';

// Date Generator API Service theo CustomAPI.md spec
// Endpoint: /api/v1/random/date
// Parameters: date_a (start date), date_b (end date), quantity, dup (allow duplicates)

class DateApiConfig extends ApiConfig {
  final DateTime dateA; // Start date
  final DateTime dateB; // End date
  final int quantity;
  final bool dup; // Allow duplicates

  DateApiConfig({
    required this.dateA,
    required this.dateB,
    required this.quantity,
    required this.dup,
  });

  factory DateApiConfig.fromJson(Map<String, dynamic> json) {
    return DateApiConfig(
      dateA: _parseDate(json['date_a']) ??
          DateTime.now().subtract(const Duration(days: 365)),
      dateB: _parseDate(json['date_b']) ??
          DateTime.now().add(const Duration(days: 365)),
      quantity: _parseInt(json['quantity']) ?? 10,
      dup: _parseBool(json['dup']) ?? true,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    if (value is int) {
      return value != 0;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => {
        'date_a': dateA.toIso8601String(),
        'date_b': dateB.toIso8601String(),
        'quantity': quantity,
        'dup': dup,
      };

  @override
  bool isValid() {
    if (quantity <= 0 || quantity > 1000) return false;
    if (dateA.isAfter(dateB)) return false;

    // Check if unique dates are possible when dup=false
    if (!dup) {
      final rangeDays = dateB.difference(dateA).inDays + 1;
      if (quantity > rangeDays) return false;
    }

    return true;
  }
}

class DateApiResult extends ApiResult {
  final List<String> results; // ISO8601 date strings
  final DateApiConfig config;

  DateApiResult({required this.results, required this.config});

  @override
  Map<String, dynamic> toJson() {
    return {
      'results': results,
      'count': results.length,
      'config': config.toJson(),
    };
  }
}

class DateApiService
    implements ApiRandomGenerator<DateApiConfig, DateApiResult> {
  @override
  String get generatorName => 'date';

  @override
  String get description => 'Generate random dates within a specified range';

  @override
  String get version => '1.0.0';

  @override
  DateApiConfig parseConfig(Map<String, dynamic> json) {
    return DateApiConfig.fromJson(json);
  }

  @override
  Future<DateApiResult> generate(DateApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for date generator');
    }

    try {
      final dates = RandomGenerator.generateRandomDates(
        startDate: config.dateA,
        endDate: config.dateB,
        count: config.quantity,
        allowDuplicates: config.dup,
      );

      final results =
          dates.map((date) => date.toIso8601String().split('T')[0]).toList();

      return DateApiResult(results: results, config: config);
    } catch (e) {
      throw ArgumentError('Failed to generate dates: ${e.toString()}');
    }
  }

  @override
  bool validateConfig(DateApiConfig config) {
    return config.isValid();
  }

  @override
  DateApiConfig getDefaultConfig() {
    return DateApiConfig(
      dateA: DateTime.now().subtract(const Duration(days: 365)),
      dateB: DateTime.now().add(const Duration(days: 365)),
      quantity: 10,
      dup: true,
    );
  }

  @override
  Map<String, dynamic> resultToJson(DateApiResult result) {
    return {
      'data': result.results,
      'metadata': {
        'count': result.results.length,
        'config': result.config.toJson(),
        'generator': generatorName,
        'version': version,
      },
    };
  }
}
