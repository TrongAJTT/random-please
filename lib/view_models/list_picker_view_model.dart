import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/providers/list_picker_generator_state_provider.dart';
import 'package:random_please/services/generation_history_service.dart';

// Temporary wrapper to maintain compatibility
class ListPickerViewModel extends ChangeNotifier {
  static const String historyType = 'listpicker';
  final WidgetRef? _ref;

  ListPickerViewModel({WidgetRef? ref}) : _ref = ref;

  List<GenerationHistoryItem> _historyItems = [];
  bool _historyEnabled = false;
  List<String> _results = [];

  // Getters - now delegate to state manager
  ListPickerGeneratorState get state {
    if (_ref != null) {
      return _ref!.watch(listPickerGeneratorStateManagerProvider);
    }
    return ListPickerGeneratorState.createDefault();
  }

  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<String> get results => _results;

  Future<void> initHive() async {
    if (_ref != null) {
      _historyEnabled = _ref!.read(historyEnabledProvider);
    } else {
      _historyEnabled = await GenerationHistoryService.isHistoryEnabled();
    }
    notifyListeners();
  }

  Future<void> loadHistory() async {
    if (_ref != null) {
      final enabled = _ref!.read(historyEnabledProvider);
      await _ref!
          .read(historyProvider.notifier)
          .loadHistoryForType(historyType);
      final history = _ref!.read(historyForTypeProvider(historyType));
      _historyEnabled = enabled;
      _historyItems = history;
    } else {
      final enabled = await GenerationHistoryService.isHistoryEnabled();
      final history = await GenerationHistoryService.getHistory(historyType);
      _historyEnabled = enabled;
      _historyItems = history;
    }
    notifyListeners();
  }

  void toggleListSelectorCollapse() {
    if (_ref != null) {
      _ref!
          .read(listPickerGeneratorStateManagerProvider.notifier)
          .toggleListSelectorCollapse();
    }
    notifyListeners();
  }

  void toggleListManagerCollapse() {
    if (_ref != null) {
      _ref!
          .read(listPickerGeneratorStateManagerProvider.notifier)
          .toggleListManagerCollapse();
    }
    notifyListeners();
  }

  void createNewList(String name) {
    if (_ref != null) {
      _ref!
          .read(listPickerGeneratorStateManagerProvider.notifier)
          .createNewList(name);
    }
    notifyListeners();
  }

  void switchToList(CustomList list) {
    if (_ref != null) {
      _ref!
          .read(listPickerGeneratorStateManagerProvider.notifier)
          .switchToList(list);
    }
    notifyListeners();
  }

  void deleteList(CustomList list) {
    if (_ref != null) {
      _ref!
          .read(listPickerGeneratorStateManagerProvider.notifier)
          .deleteList(list);
    }
    notifyListeners();
  }

  void renameList(CustomList list, String newName) {
    if (_ref != null) {
      _ref!
          .read(listPickerGeneratorStateManagerProvider.notifier)
          .renameList(list, newName);
    }
    notifyListeners();
  }

  void addItemToCurrentList(String itemValue) {
    if (_ref != null) {
      _ref!
          .read(listPickerGeneratorStateManagerProvider.notifier)
          .addItemToCurrentList(itemValue);
    }
    notifyListeners();
  }

  Future<void> addBatchItems(List<String> items) async {
    if (_ref != null) {
      await _ref!
          .read(listPickerGeneratorStateManagerProvider.notifier)
          .addBatchItemsToCurrentList(items);
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    final currentState = state;
    if (_ref != null && currentState.currentList != null) {
      final index = currentState.currentList!.items
          .indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _ref!
            .read(listPickerGeneratorStateManagerProvider.notifier)
            .removeItemFromCurrentList(index);
      }
    }
    notifyListeners();
  }

  void renameItem(ListItem item, String newValue) {
    final currentState = state;
    if (_ref != null && currentState.currentList != null) {
      final index =
          currentState.currentList!.items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _ref!
            .read(listPickerGeneratorStateManagerProvider.notifier)
            .editItemInCurrentList(index, newValue);
      }
    }
    notifyListeners();
  }

  void updateMode(ListPickerMode mode) {
    if (_ref != null) {
      _ref!
          .read(listPickerGeneratorStateManagerProvider.notifier)
          .updateMode(mode);

      // Adjust quantity to fit new mode constraints
      final currentState = state;
      final maxItems = currentState.currentList?.items.length ?? 0;

      switch (mode) {
        case ListPickerMode.random:
          final newQuantity =
              currentState.quantity.clamp(1, (maxItems - 1).clamp(1, maxItems));
          if (newQuantity != currentState.quantity) {
            _ref!
                .read(listPickerGeneratorStateManagerProvider.notifier)
                .updateQuantity(newQuantity);
          }
          break;
        case ListPickerMode.shuffle:
          final newQuantity = currentState.quantity.clamp(2, maxItems);
          if (newQuantity != currentState.quantity) {
            _ref!
                .read(listPickerGeneratorStateManagerProvider.notifier)
                .updateQuantity(newQuantity);
          }
          break;
        case ListPickerMode.team:
          final newQuantity = currentState.quantity
              .clamp(2, (maxItems / 2).ceil().clamp(2, maxItems));
          if (newQuantity != currentState.quantity) {
            _ref!
                .read(listPickerGeneratorStateManagerProvider.notifier)
                .updateQuantity(newQuantity);
          }
          break;
      }
    }
    notifyListeners();
  }

  void updateQuantity(int quantity) {
    if (_ref != null) {
      _ref!
          .read(listPickerGeneratorStateManagerProvider.notifier)
          .updateQuantity(quantity);
    }
    notifyListeners();
  }

  Future<void> pickRandomItems() async {
    final currentState = state;
    if (currentState.currentList == null ||
        currentState.currentList!.items.isEmpty) {
      return;
    }

    final items = List<ListItem>.from(currentState.currentList!.items);
    List<String> results = [];

    switch (currentState.mode) {
      case ListPickerMode.random:
        items.shuffle();
        final count = currentState.quantity
            .clamp(1, (items.length - 1).clamp(1, items.length));
        results = items.take(count).map((item) => item.value).toList();
        break;

      case ListPickerMode.shuffle:
        items.shuffle();
        final count = currentState.quantity.clamp(2, items.length);
        results = items.take(count).map((item) => item.value).toList();
        break;

      case ListPickerMode.team:
        items.shuffle();
        final numberOfTeams = currentState.quantity
            .clamp(2, (items.length / 2).ceil().clamp(2, items.length));
        final itemsPerTeam = (items.length / numberOfTeams).ceil();

        results = [];
        for (int i = 0; i < numberOfTeams; i++) {
          final startIndex = i * itemsPerTeam;
          final endIndex = ((i + 1) * itemsPerTeam).clamp(0, items.length);
          if (startIndex < items.length) {
            final teamItems = items.sublist(startIndex, endIndex);
            final teamNames = teamItems.map((item) => item.value).join(', ');
            results.add('Team ${i + 1}: $teamNames');
          }
        }
        break;
    }

    _results = results;
    notifyListeners();

    // Save to history if enabled using new standardized encoding
    if (_historyEnabled && _results.isNotEmpty && _ref != null) {
      await _ref!
          .read(historyProvider.notifier)
          .addHistoryItems(_results, historyType);
    }
  }

  Future<void> clearAllHistory() async {
    if (_ref != null) {
      await _ref!.read(historyProvider.notifier).clearHistory(historyType);
    }
  }

  Future<void> clearPinnedHistory() async {
    if (_ref != null) {
      await _ref!
          .read(historyProvider.notifier)
          .clearPinnedHistory(historyType);
    }
  }

  Future<void> clearUnpinnedHistory() async {
    if (_ref != null) {
      await _ref!
          .read(historyProvider.notifier)
          .clearUnpinnedHistory(historyType);
    }
  }

  Future<void> deleteHistoryItem(int index) async {
    if (_ref != null) {
      await _ref!
          .read(historyProvider.notifier)
          .deleteHistoryItem(historyType, index);
    }
  }

  Future<void> togglePinHistoryItem(int index) async {
    if (_ref != null) {
      await _ref!
          .read(historyProvider.notifier)
          .togglePinHistoryItem(historyType, index);
    }
  }
}
