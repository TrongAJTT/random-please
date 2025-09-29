import '../interfaces/api_random_generator.dart';
import '../models/api_models.dart';
import '../../models/random_models/random_state_models.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

// List Picker Generator API Service - Updated spec
// Endpoints:
// - GET /api/v1/random/list
// Parameters:
// - index: Chọn list từ Hive (mặc định 0 = list đầu tiên)  
// - items: Custom list (ghi đè index nếu có)
// - mode: random|shuffle|team (mặc định random)
// - quantity: số lượng (mặc định 1)

class ListPickerApiConfig extends ApiConfig {
  final int? index; // Index của list trong Hive (null nếu dùng custom items)
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
    
    // Parse custom items if provided
    if (json['items'] != null) {
      if (json['items'] is String) {
        // Comma-separated values
        customItems = (json['items'] as String)
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (json['items'] is List) {
        // Array format
        customItems = (json['items'] as List)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    return ListPickerApiConfig(
      index: customItems == null ? _parseInt(json['index']) ?? 0 : null,
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
    
    // Phải có items hoặc index hợp lệ
    if (items == null && index == null) return false;
    if (items != null && items!.isEmpty) return false;
    if (index != null && index! < 0) return false;
    
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
  final Random _random = Random();
  static const String _boxName = 'listPickerGeneratorBox';

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

  // Lấy list từ Hive storage
  Future<List<String>?> _getListFromHive(int index) async {
    try {
      final box = await Hive.openBox<ListPickerGeneratorState>(_boxName);
      final state = box.get('state');
      
      if (state == null || state.savedLists.isEmpty) {
        return null;
      }
      
      if (index >= state.savedLists.length) {
        return null;
      }
      
      final selectedList = state.savedLists[index];
      return selectedList.items.map((item) => item.value).toList();
    } catch (e) {
      return null;
    }
  }

  // Lấy tên list từ Hive storage
  Future<String?> _getListNameFromHive(int index) async {
    try {
      final box = await Hive.openBox<ListPickerGeneratorState>(_boxName);
      final state = box.get('state');
      
      if (state == null || state.savedLists.isEmpty) {
        return null;
      }
      
      if (index >= state.savedLists.length) {
        return null;
      }
      
      return state.savedLists[index].name;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ListPickerApiResult> generate(ListPickerApiConfig config) async {
    if (!validateConfig(config)) {
      throw ArgumentError('Invalid configuration for list picker generator');
    }

    try {
      List<String> items;
      String? listName;

      // Sử dụng custom items nếu có, nếu không thì lấy từ Hive
      if (config.items != null) {
        items = List<String>.from(config.items!);
        listName = 'Custom List';
      } else {
        final hiveItems = await _getListFromHive(config.index ?? 0);
        if (hiveItems == null || hiveItems.isEmpty) {
          throw ArgumentError('No lists available in the application. Please create a list first.');
        }
        items = hiveItems;
        listName = await _getListNameFromHive(config.index ?? 0);
      }

      // Validate items vs mode and quantity
      if (!_validateItemsForMode(items, config.mode, config.quantity)) {
        throw ArgumentError('Invalid quantity for ${config.mode} mode with ${items.length} items');
      }

      List<String> results = [];

      switch (config.mode) {
        case 'random':
          items.shuffle(_random);
          final count = config.quantity.clamp(1, (items.length - 1).clamp(1, items.length));
          results = items.take(count).toList();
          break;

        case 'shuffle':
          items.shuffle(_random);
          final count = config.quantity.clamp(2, items.length);
          results = items.take(count).toList();
          break;

        case 'team':
          items.shuffle(_random);
          final numberOfTeams = config.quantity.clamp(2, (items.length / 2).ceil().clamp(2, items.length));
          final itemsPerTeam = (items.length / numberOfTeams).ceil();

          results = [];
          for (int i = 0; i < numberOfTeams; i++) {
            final startIndex = i * itemsPerTeam;
            final endIndex = ((i + 1) * itemsPerTeam).clamp(0, items.length);
            if (startIndex < items.length) {
              final teamItems = items.sublist(startIndex, endIndex);
              final teamNames = teamItems.join(', ');
              results.add('Team ${i + 1}: $teamNames');
            }
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
        return quantity >= 2 && items.length >= 3 && quantity <= (items.length / 2).ceil();
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
      index: 0, // Use first list by default
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
        'used_index': result.config.index,
        'used_custom_items': result.config.items != null,
        'config': result.config.toJson(),
        'generator': generatorName,
        'version': version,
      },
    };
  }
}
