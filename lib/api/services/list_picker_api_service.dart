import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';
// Removed Hive dependencies: list selection now only uses `items`
import '../../models/random_generator.dart' as main_random;

// List Picker Generator API Service - Updated spec
// Endpoints:
// - GET /api/v1/random/list
// Parameters:
// - items: Custom list (mặc định: a,b,c,d,e,f,g,h,i)
// - mode: random|shuffle|team (mặc định random)
// - quantity: số lượng (mặc định 1)

class ListPickerApiConfig extends ApiConfig {
  final int? index; // Deprecated: Không còn sử dụng
  final List<String>? items; // Custom items list (ghi đè index)
  final String mode; // 'random', 'shuffle', 'team'
  final int quantity;

  ListPickerApiConfig({
    this.index,
    this.items,
    required this.mode,
    required this.quantity,
  });

  factory ListPickerApiConfig.fromJson(Map<String, dynamic> json) {
    List<String>? customItems;

    // Parse custom items if provided, else use default a..i
    if (json['items'] != null) {
      if (json['items'] is String) {
        customItems = (json['items'] as String)
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (json['items'] is List) {
        customItems = (json['items'] as List)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    } else {
      customItems = const ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'];
    }

    return ListPickerApiConfig(
      index: null, // deprecated
      items: customItems,
      mode: (json['mode'] as String?) ?? 'random',
      quantity: _parseInt(json['quantity']) ?? 1,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => {
        'index': index,
        'items': items,
        'mode': mode,
        'quantity': quantity,
      };

  @override
  bool isValid() {
    if (quantity <= 0 || quantity > 1000) return false;
    if (!['random', 'shuffle', 'team'].contains(mode)) return false;

    // Phải có items hợp lệ
    if (items == null || items!.isEmpty) return false;

    return true;
  }
}

class ListPickerApiResult extends ApiResult {
  final List<String> results;
  final ListPickerApiConfig config;
  final String? listName; // Tên của list được sử dụng

  ListPickerApiResult({
    required this.results,
    required this.config,
    this.listName,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'results': results,
      'count': results.length,
      'mode': config.mode,
      'list_name': listName,
      'config': config.toJson(),
    };
  }
}

class ListPickerApiService
    implements ApiRandomGenerator<ListPickerApiConfig, ListPickerApiResult> {
  // Deprecated: no longer used
  // static const String _boxName = 'listPickerGeneratorBox';

  @override
  String get generatorName => 'list';

  @override
  String get description =>
      'Pick random items from saved lists or custom items with different modes';

  @override
  String get version => '1.0.0';

  @override
  ListPickerApiConfig parseConfig(Map<String, dynamic> json) {
    return ListPickerApiConfig.fromJson(json);
  }

  // Deprecated Hive accessors removed (list selection now relies solely on `items`)

  @override
  Future<ListPickerApiResult> generate(ListPickerApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for list picker generator');
    }

    try {
      List<String> items;
      String? listName;

      // Luôn sử dụng items, đã có mặc định a..i
      items = List<String>.from(
          config.items ?? const ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i']);
      listName = 'Custom List';

      // Validate items vs mode and quantity
      if (!_validateItemsForMode(items, config.mode, config.quantity)) {
        throw ArgumentError(
            'Invalid quantity for ${config.mode} mode with ${items.length} items');
      }

      List<String> results = [];

      switch (config.mode) {
        case 'random':
          results = main_random.RandomGenerator.pickRandomItems(
            items,
            quantity: config.quantity,
          );
          break;

        case 'shuffle':
          results = main_random.RandomGenerator.shuffleTake(
            items,
            quantity: config.quantity,
          );
          break;

        case 'team':
          final teams = main_random.RandomGenerator.splitIntoTeams(
            items,
            teams: config.quantity,
          );

          // Convert teams to formatted strings
          results = [];
          for (int i = 0; i < teams.length; i++) {
            final teamItems = teams[i].join(', ');
            results.add('Team ${i + 1}: $teamItems');
          }
          break;
      }

      return ListPickerApiResult(
        results: results,
        config: config,
        listName: listName,
      );
    } catch (e) {
      throw ArgumentError('Failed to pick from list: ${e.toString()}');
    }
  }

  bool _validateItemsForMode(List<String> items, String mode, int quantity) {
    if (items.isEmpty) return false;

    switch (mode) {
      case 'random':
        return quantity > 0 && quantity < items.length;
      case 'shuffle':
        return quantity >= 2 && quantity <= items.length;
      case 'team':
        return quantity >= 2 &&
            items.length >= 3 &&
            quantity <= (items.length / 2).ceil();
      default:
        return false;
    }
  }

  @override
  bool validateConfig(ListPickerApiConfig config) {
    return config.isValid();
  }

  @override
  ListPickerApiConfig getDefaultConfig() {
    return ListPickerApiConfig(
      index: null,
      items: const ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'],
      mode: 'random',
      quantity: 1,
    );
  }

  @override
  Map<String, dynamic> resultToJson(ListPickerApiResult result) {
    return {
      'data': result.results,
      'metadata': {
        'count': result.results.length,
        'mode': result.config.mode,
        'list_name': result.listName,
        'used_index': null,
        'used_custom_items': true,
        'config': result.config.toJson(),
        'generator': generatorName,
        'version': version,
      },
    };
  }
}
