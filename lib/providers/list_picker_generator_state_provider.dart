import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/providers/settings_provider.dart';

// StateManager cho ListPickerGenerator với persistent state
class ListPickerGeneratorStateManager
    extends StateNotifier<ListPickerGeneratorState> {
  static const String _stateKey = 'listPickerGeneratorState';
  final Ref ref;

  ListPickerGeneratorStateManager(this.ref)
      : super(ListPickerGeneratorState.createDefault()) {
    _loadState();
  }

  Future<void> _loadState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = prefs.getString(_stateKey);

      if (stateJson != null) {
        try {
          // Parse full state from JSON
          final Map<String, dynamic> stateMap = jsonDecode(stateJson);
          state = ListPickerGeneratorState.fromJson(stateMap);
        } catch (e) {
          // If loading fails, try to load individual fields for backward compatibility
          try {
            final quantity = prefs.getInt('${_stateKey}_quantity') ?? 1;
            final mode = prefs.getString('${_stateKey}_mode') ?? 'random';
            final isListSelectorCollapsed =
                prefs.getBool('${_stateKey}_isListSelectorCollapsed') ?? false;
            final isListManagerCollapsed =
                prefs.getBool('${_stateKey}_isListManagerCollapsed') ?? false;

            state = state.copyWith(
              quantity: quantity,
              mode: ListPickerMode.values.firstWhere(
                (m) => m.name == mode,
                orElse: () => ListPickerMode.random,
              ),
              isListSelectorCollapsed: isListSelectorCollapsed,
              listManagerExpandState: isListManagerCollapsed
                  ? ListManagerExpandState.minimized
                  : ListManagerExpandState.expanded,
            );
          } catch (e2) {
            // If both fail, use default state
            state = ListPickerGeneratorState.createDefault();
          }
        }
      }
    }
  }

  Future<void> _saveState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();

      // Save full state as JSON to preserve all data including customLists
      final stateJson = jsonEncode(state.toJson());
      await prefs.setString(_stateKey, stateJson);

      // Also save individual fields for backward compatibility
      await prefs.setInt('${_stateKey}_quantity', state.quantity);
      await prefs.setString('${_stateKey}_mode', state.mode.name);
      await prefs.setBool('${_stateKey}_isListSelectorCollapsed',
          state.isListSelectorCollapsed);
      await prefs.setBool('${_stateKey}_isListManagerCollapsed',
          state.listManagerExpandState == ListManagerExpandState.minimized);
    }
  }

  // Update methods với auto-save
  void updateQuantity(int quantity) {
    state = state.copyWith(quantity: quantity);
    _saveState();
  }

  void updateMode(ListPickerMode mode) {
    state = state.copyWith(mode: mode);
    _saveState();
  }

  void toggleListSelectorCollapse() {
    state = state.copyWith(
      isListSelectorCollapsed: !state.isListSelectorCollapsed,
      lastUpdated: DateTime.now(),
    );
    _saveState();
  }

  void toggleListManagerCollapse() {
    ListManagerExpandState newState;
    switch (state.listManagerExpandState) {
      case ListManagerExpandState.expanded:
        newState = ListManagerExpandState.collapsed;
        break;
      case ListManagerExpandState.collapsed:
        newState = ListManagerExpandState.minimized;
        break;
      case ListManagerExpandState.minimized:
        newState = ListManagerExpandState.expanded;
        break;
    }

    state = state.copyWith(
      listManagerExpandState: newState,
      lastUpdated: DateTime.now(),
    );
    _saveState();
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
    _saveState();
  }

  void switchToList(CustomList list) {
    state = state.copyWith(
      currentList: list,
      lastUpdated: DateTime.now(),
    );
    _saveState();
  }

  void deleteList(CustomList list) {
    final updatedSavedLists = List<CustomList>.from(state.savedLists)
      ..removeWhere((l) => l.id == list.id);

    CustomList? newCurrentList = state.currentList?.id == list.id
        ? (updatedSavedLists.isNotEmpty ? updatedSavedLists.first : null)
        : state.currentList;

    state = state.copyWith(
      savedLists: updatedSavedLists,
      currentList: newCurrentList,
      lastUpdated: DateTime.now(),
    );
    _saveState();
  }

  void renameList(CustomList list, String newName) {
    final updatedSavedLists = List<CustomList>.from(state.savedLists);
    final index = updatedSavedLists.indexWhere((l) => l.id == list.id);

    if (index != -1) {
      // Create a new CustomList with updated name
      final updatedList = CustomList(
        id: list.id,
        name: newName,
        items: list.items,
        createdAt: list.createdAt,
      );

      updatedSavedLists[index] = updatedList;

      state = state.copyWith(
        savedLists: updatedSavedLists,
        currentList:
            state.currentList?.id == list.id ? updatedList : state.currentList,
        lastUpdated: DateTime.now(),
      );
      _saveState();
    }
  }

  void addItemToCurrentList(String itemValue) {
    if (itemValue.isNotEmpty && state.currentList != null) {
      final currentList = state.currentList!;
      final newItem = ListItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        value: itemValue,
        createdAt: DateTime.now(),
      );
      final updatedItems = List<ListItem>.from(currentList.items)..add(newItem);

      final updatedList = CustomList(
        id: currentList.id,
        name: currentList.name,
        items: updatedItems,
        createdAt: currentList.createdAt,
      );

      final updatedSavedLists = List<CustomList>.from(state.savedLists);
      final index = updatedSavedLists.indexWhere((l) => l.id == currentList.id);

      if (index != -1) {
        updatedSavedLists[index] = updatedList;
      }

      state = state.copyWith(
        savedLists: updatedSavedLists,
        currentList: updatedList,
        lastUpdated: DateTime.now(),
      );
      _saveState();
    }
  }

  // Alias for consistency with ViewModel
  Future<void> addBatchItems(List<String> itemValues) async {
    await addBatchItemsToCurrentList(itemValues);
  }

  // Efficient batch add - only save once at the end
  Future<void> addBatchItemsToCurrentList(List<String> itemValues) async {
    if (itemValues.isEmpty || state.currentList == null) return;

    final currentList = state.currentList!;
    final newItems = <ListItem>[];

    for (final itemValue in itemValues) {
      final trimmedValue = itemValue.trim();
      if (trimmedValue.isNotEmpty) {
        newItems.add(ListItem(
          id: '${DateTime.now().millisecondsSinceEpoch}_${newItems.length}',
          value: trimmedValue,
          createdAt: DateTime.now(),
        ));
      }
    }

    if (newItems.isNotEmpty) {
      final updatedItems = List<ListItem>.from(currentList.items)
        ..addAll(newItems);

      final updatedList = CustomList(
        id: currentList.id,
        name: currentList.name,
        items: updatedItems,
        createdAt: currentList.createdAt,
      );

      final updatedSavedLists = List<CustomList>.from(state.savedLists);
      final index = updatedSavedLists.indexWhere((l) => l.id == currentList.id);

      if (index != -1) {
        updatedSavedLists[index] = updatedList;
      }

      state = state.copyWith(
        savedLists: updatedSavedLists,
        currentList: updatedList,
        lastUpdated: DateTime.now(),
      );

      // Only save once at the end
      await _saveState();
    }
  }

  void removeItem(String itemId) {
    if (state.currentList != null) {
      final index =
          state.currentList!.items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        removeItemFromCurrentList(index);
      }
    }
  }

  void removeItemFromCurrentList(int index) {
    if (state.currentList != null &&
        index >= 0 &&
        index < state.currentList!.items.length) {
      final currentList = state.currentList!;
      final updatedItems = List<ListItem>.from(currentList.items)
        ..removeAt(index);

      final updatedList = CustomList(
        id: currentList.id,
        name: currentList.name,
        items: updatedItems,
        createdAt: currentList.createdAt,
      );

      final updatedSavedLists = List<CustomList>.from(state.savedLists);
      final listIndex =
          updatedSavedLists.indexWhere((l) => l.id == currentList.id);

      if (listIndex != -1) {
        updatedSavedLists[listIndex] = updatedList;
      }

      state = state.copyWith(
        savedLists: updatedSavedLists,
        currentList: updatedList,
        lastUpdated: DateTime.now(),
      );
      _saveState();
    }
  }

  void renameItem(ListItem item, String newValue) {
    if (state.currentList != null) {
      final index = state.currentList!.items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        editItemInCurrentList(index, newValue);
      }
    }
  }

  void editItemInCurrentList(int index, String newValue) {
    if (state.currentList != null &&
        index >= 0 &&
        index < state.currentList!.items.length) {
      final currentList = state.currentList!;
      final updatedItems = List<ListItem>.from(currentList.items);
      updatedItems[index] = ListItem(
        id: updatedItems[index].id,
        value: newValue,
        createdAt: updatedItems[index].createdAt,
      );

      final updatedList = CustomList(
        id: currentList.id,
        name: currentList.name,
        items: updatedItems,
        createdAt: currentList.createdAt,
      );

      final updatedSavedLists = List<CustomList>.from(state.savedLists);
      final listIndex =
          updatedSavedLists.indexWhere((l) => l.id == currentList.id);

      if (listIndex != -1) {
        updatedSavedLists[listIndex] = updatedList;
      }

      state = state.copyWith(
        savedLists: updatedSavedLists,
        currentList: updatedList,
        lastUpdated: DateTime.now(),
      );
      _saveState();
    }
  }

  // Pick random items based on current state and mode
  Future<List<String>> pickRandomItems() async {
    if (state.currentList == null || state.currentList!.items.isEmpty) {
      return [];
    }

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

    return results;
  }

  // Reset về default
  void resetToDefault() {
    state = ListPickerGeneratorState.createDefault();
    _saveState();
  }

  // Force reload state (khi setting thay đổi)
  Future<void> reloadState() async {
    await _loadState();
  }
}

// Provider cho ListPickerGenerator state manager
final listPickerGeneratorStateManagerProvider = StateNotifierProvider<
    ListPickerGeneratorStateManager, ListPickerGeneratorState>((ref) {
  return ListPickerGeneratorStateManager(ref);
});
