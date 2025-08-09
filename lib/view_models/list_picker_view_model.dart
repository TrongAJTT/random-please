import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';

class ListPickerViewModel extends ChangeNotifier {
  static const String boxName = 'listPickerGeneratorBox';
  static const String historyType = 'listpicker';

  late Box<ListPickerGeneratorState> _box;
  ListPickerGeneratorState _state = ListPickerGeneratorState.createDefault();
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<String> _results = [];

  // Getters
  ListPickerGeneratorState get state => _state;
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<String> get results => _results;

  Future<void> initHive() async {
    _box = await Hive.openBox<ListPickerGeneratorState>(boxName);
    _state = _box.get('state') ?? ListPickerGeneratorState.createDefault();
    _isBoxOpen = true;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);
    _historyEnabled = enabled;
    _historyItems = history;
    notifyListeners();
  }

  void saveState() {
    if (_isBoxOpen) {
      _box.put('state', _state);
    }
  }

  void toggleListSelectorCollapse() {
    _state.isListSelectorCollapsed = !_state.isListSelectorCollapsed;
    _state.lastUpdated = DateTime.now();
    saveState();
    notifyListeners();
  }

  void toggleListManagerCollapse() {
    _state.isListManagerCollapsed = !_state.isListManagerCollapsed;
    _state.lastUpdated = DateTime.now();
    saveState();
    notifyListeners();
  }

  void createNewList(String name) {
    final newList = CustomList(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      items: [],
      createdAt: DateTime.now(),
    );

    _state.savedLists.add(newList);
    _state.currentList = newList;
    _state.lastUpdated = DateTime.now();
    saveState();
    notifyListeners();
  }

  void switchToList(CustomList list) {
    _state.currentList = list;
    _state.lastUpdated = DateTime.now();
    saveState();
    notifyListeners();
  }

  void deleteList(CustomList list) {
    _state.savedLists.removeWhere((l) => l.id == list.id);
    if (_state.currentList?.id == list.id) {
      _state.currentList =
          _state.savedLists.isNotEmpty ? _state.savedLists.first : null;
    }
    _state.lastUpdated = DateTime.now();
    saveState();
    notifyListeners();
  }

  void renameList(CustomList list, String newName) {
    list.name = newName;
    _state.lastUpdated = DateTime.now();
    saveState();
    notifyListeners();
  }

  void addItemToCurrentList(String itemValue) {
    if (itemValue.isNotEmpty && _state.currentList != null) {
      _state.currentList!.items.add(ListItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        value: itemValue,
        createdAt: DateTime.now(),
      ));
      _state.lastUpdated = DateTime.now();
      saveState();
      notifyListeners();
    }
  }

  void addBatchItems(List<String> items) {
    if (_state.currentList != null) {
      final now = DateTime.now();
      for (int i = 0; i < items.length; i++) {
        final trimmedItem = items[i].trim();
        if (trimmedItem.isNotEmpty) {
          _state.currentList!.items.add(ListItem(
            id: '${now.millisecondsSinceEpoch}_${_state.currentList!.items.length + i}',
            value: trimmedItem,
            createdAt: now,
          ));
        }
      }
      _state.lastUpdated = now;
      saveState();
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    if (_state.currentList != null) {
      _state.currentList!.items.removeWhere((item) => item.id == itemId);
      _state.lastUpdated = DateTime.now();
      saveState();
      notifyListeners();
    }
  }

  void renameItem(ListItem item, String newValue) {
    item.value = newValue;
    _state.lastUpdated = DateTime.now();
    saveState();
    notifyListeners();
  }

  void updateMode(ListPickerMode mode) {
    _state.mode = mode;
    final maxItems = _state.currentList?.items.length ?? 0;

    // Adjust quantity to fit new mode constraints
    switch (mode) {
      case ListPickerMode.random:
        _state.quantity =
            _state.quantity.clamp(1, (maxItems - 1).clamp(1, maxItems));
        break;
      case ListPickerMode.shuffle:
        _state.quantity = _state.quantity.clamp(2, maxItems);
        break;
      case ListPickerMode.team:
        _state.quantity =
            _state.quantity.clamp(2, (maxItems / 2).ceil().clamp(2, maxItems));
        break;
    }
    _state.lastUpdated = DateTime.now();
    saveState();
    notifyListeners();
  }

  void updateQuantity(int quantity) {
    _state.quantity = quantity;
    _state.lastUpdated = DateTime.now();
    saveState();
    notifyListeners();
  }

  Future<void> pickRandomItems() async {
    if (_state.currentList == null || _state.currentList!.items.isEmpty) return;

    final items = List<ListItem>.from(_state.currentList!.items);
    List<String> results = [];

    switch (_state.mode) {
      case ListPickerMode.random:
        items.shuffle();
        final count =
            _state.quantity.clamp(1, (items.length - 1).clamp(1, items.length));
        results = items.take(count).map((item) => item.value).toList();
        break;

      case ListPickerMode.shuffle:
        items.shuffle();
        final count = _state.quantity.clamp(2, items.length);
        results = items.take(count).map((item) => item.value).toList();
        break;

      case ListPickerMode.team:
        items.shuffle();
        final numberOfTeams = _state.quantity
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

    // Save to history if enabled
    if (_historyEnabled && _results.isNotEmpty) {
      await GenerationHistoryService.addHistoryItem(
          _results.join('; '), historyType);
      await loadHistory();
    }
  }

  Future<void> clearAllHistory() async {
    await GenerationHistoryService.clearHistory(historyType);
    await loadHistory();
  }

  Future<void> clearPinnedHistory() async {
    await GenerationHistoryService.clearPinnedHistory(historyType);
    await loadHistory();
  }

  Future<void> clearUnpinnedHistory() async {
    await GenerationHistoryService.clearUnpinnedHistory(historyType);
    await loadHistory();
  }

  Future<void> deleteHistoryItem(int index) async {
    await GenerationHistoryService.deleteHistoryItem(historyType, index);
    await loadHistory();
  }

  Future<void> togglePinHistoryItem(int index) async {
    await GenerationHistoryService.togglePinHistoryItem(historyType, index);
    await loadHistory();
  }

  @override
  void dispose() {
    _box.close();
    super.dispose();
  }
}
