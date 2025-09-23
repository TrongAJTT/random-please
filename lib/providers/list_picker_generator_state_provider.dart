import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          // Parse basic fields from JSON string if needed
          // For simplicity, we'll load individual fields
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
            isListManagerCollapsed: isListManagerCollapsed,
          );
        } catch (e) {
          // If loading fails, use default state
          state = ListPickerGeneratorState.createDefault();
        }
      }
    }
  }

  Future<void> _saveState() async {
    final saveState = ref.read(saveRandomToolsStateProvider);

    if (saveState) {
      final prefs = await SharedPreferences.getInstance();

      // Save individual fields
      await prefs.setInt('${_stateKey}_quantity', state.quantity);
      await prefs.setString('${_stateKey}_mode', state.mode.name);
      await prefs.setBool('${_stateKey}_isListSelectorCollapsed',
          state.isListSelectorCollapsed);
      await prefs.setBool(
          '${_stateKey}_isListManagerCollapsed', state.isListManagerCollapsed);
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
    state = state.copyWith(
      isListManagerCollapsed: !state.isListManagerCollapsed,
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
