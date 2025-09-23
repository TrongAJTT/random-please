import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/services/generation_history_service.dart';

class ListPickerNotifier extends StateNotifier<ListPickerGeneratorState> {
  static const String boxName = 'listPickerGeneratorBox';
  static const String historyType = 'listpicker';

  late Box<ListPickerGeneratorState> _box;
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];
  List<String> _results = [];

  ListPickerNotifier() : super(ListPickerGeneratorState.createDefault()) {
    _init();
  }

  // Getters
  bool get isBoxOpen => _isBoxOpen;
  bool get historyEnabled => _historyEnabled;
  List<GenerationHistoryItem> get historyItems => _historyItems;
  List<String> get results => _results;

  Future<void> _init() async {
    await initHive();
    await loadHistory();
  }

  Future<void> initHive() async {
    _box = await Hive.openBox<ListPickerGeneratorState>(boxName);
    final savedState =
        _box.get('state') ?? ListPickerGeneratorState.createDefault();
    state = savedState;
    _isBoxOpen = true;
  }

  Future<void> loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(historyType);
    _historyEnabled = enabled;
    _historyItems = history;
  }

  void saveState() {
    if (_isBoxOpen) {
      _box.put('state', state);
    }
  }

  void toggleListSelectorCollapse() {
    state = state.copyWith(
      isListSelectorCollapsed: !state.isListSelectorCollapsed,
      lastUpdated: DateTime.now(),
    );
    saveState();
  }

  void toggleListManagerCollapse() {
    state = state.copyWith(
      isListManagerCollapsed: !state.isListManagerCollapsed,
      lastUpdated: DateTime.now(),
    );
    saveState();
  }

  void createNewList(String name) {
    final newList = CustomList(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      items: [],
      createdAt: DateTime.now(),
    );

    final updatedSavedLists = List<CustomList>.from(state.savedLists)
      ..add(newList);

    state = state.copyWith(
      savedLists: updatedSavedLists,
      currentList: newList,
      lastUpdated: DateTime.now(),
    );
    saveState();
  }

  void switchToList(CustomList list) {
    state = state.copyWith(
      currentList: list,
      lastUpdated: DateTime.now(),
    );
    saveState();
  }

  void deleteList(CustomList list) {
    final updatedSavedLists = List<CustomList>.from(state.savedLists)
      ..removeWhere((l) => l.id == list.id);

    CustomList? newCurrentList = state.currentList;
    if (state.currentList?.id == list.id) {
      newCurrentList =
          updatedSavedLists.isNotEmpty ? updatedSavedLists.first : null;
    }

    state = state.copyWith(
      savedLists: updatedSavedLists,
      currentList: newCurrentList,
      lastUpdated: DateTime.now(),
    );
    saveState();
  }

  void renameList(CustomList list, String newName) {
    list.name = newName;
    state = state.copyWith(lastUpdated: DateTime.now());
    saveState();
  }

  void addItemToCurrentList(String itemValue) {
    if (itemValue.isNotEmpty && state.currentList != null) {
      final currentList = state.currentList!;
      final newItem = ListItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        value: itemValue,
        createdAt: DateTime.now(),
      );

      currentList.items.add(newItem);
      state = state.copyWith(lastUpdated: DateTime.now());
      saveState();
    }
  }

  void addBatchItems(List<String> items) {
    if (state.currentList != null) {
      final now = DateTime.now();
      final currentList = state.currentList!;

      for (int i = 0; i < items.length; i++) {
        final trimmedItem = items[i].trim();
        if (trimmedItem.isNotEmpty) {
          currentList.items.add(ListItem(
            id: '${now.millisecondsSinceEpoch}_${currentList.items.length + i}',
            value: trimmedItem,
            createdAt: now,
          ));
        }
      }
      state = state.copyWith(lastUpdated: now);
      saveState();
    }
  }

  void removeItem(String itemId) {
    if (state.currentList != null) {
      state.currentList!.items.removeWhere((item) => item.id == itemId);
      state = state.copyWith(lastUpdated: DateTime.now());
      saveState();
    }
  }

  void renameItem(ListItem item, String newValue) {
    item.value = newValue;
    state = state.copyWith(lastUpdated: DateTime.now());
    saveState();
  }

  void updateMode(ListPickerMode mode) {
    final maxItems = state.currentList?.items.length ?? 0;
    int newQuantity = state.quantity;

    // Adjust quantity to fit new mode constraints
    switch (mode) {
      case ListPickerMode.random:
        newQuantity = newQuantity.clamp(1, (maxItems - 1).clamp(1, maxItems));
        break;
      case ListPickerMode.shuffle:
        newQuantity = newQuantity.clamp(2, maxItems);
        break;
      case ListPickerMode.team:
        newQuantity =
            newQuantity.clamp(2, (maxItems / 2).ceil().clamp(2, maxItems));
        break;
    }

    state = state.copyWith(
      mode: mode,
      quantity: newQuantity,
      lastUpdated: DateTime.now(),
    );
    saveState();
  }

  void updateQuantity(int quantity) {
    state = state.copyWith(
      quantity: quantity,
      lastUpdated: DateTime.now(),
    );
    saveState();
  }

  Future<void> pickRandomItems() async {
    if (state.currentList == null || state.currentList!.items.isEmpty) return;

    final items = List<ListItem>.from(state.currentList!.items);
    List<String> results = [];

    switch (state.mode) {
      case ListPickerMode.random:
        items.shuffle();
        final count =
            state.quantity.clamp(1, (items.length - 1).clamp(1, items.length));
        results = items.take(count).map((item) => item.value).toList();
        break;

      case ListPickerMode.shuffle:
        items.shuffle();
        final count = state.quantity.clamp(2, items.length);
        results = items.take(count).map((item) => item.value).toList();
        break;

      case ListPickerMode.team:
        items.shuffle();
        final numberOfTeams = state.quantity
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
}

final listPickerProvider =
    StateNotifierProvider<ListPickerNotifier, ListPickerGeneratorState>(
  (ref) => ListPickerNotifier(),
);
