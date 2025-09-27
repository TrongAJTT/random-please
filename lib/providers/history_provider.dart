import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/services/generation_history_service.dart';

// State for history management
class HistoryState {
  final Map<String, List<GenerationHistoryItem>> historyByType;
  final bool isHistoryEnabled;
  final bool isLoading;

  const HistoryState({
    required this.historyByType,
    required this.isHistoryEnabled,
    required this.isLoading,
  });

  HistoryState copyWith({
    Map<String, List<GenerationHistoryItem>>? historyByType,
    bool? isHistoryEnabled,
    bool? isLoading,
  }) {
    return HistoryState(
      historyByType: historyByType ?? this.historyByType,
      isHistoryEnabled: isHistoryEnabled ?? this.isHistoryEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<GenerationHistoryItem> getHistoryForType(String type) {
    return historyByType[type] ?? [];
  }
}

// History notifier to manage all history operations
class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier()
      : super(const HistoryState(
          historyByType: {},
          isHistoryEnabled: true,
          isLoading: false,
        )) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    state = state.copyWith(isLoading: true);
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    state = state.copyWith(
      isHistoryEnabled: enabled,
      isLoading: false,
    );
  }

  // Load history for a specific type
  Future<void> loadHistoryForType(String type) async {
    final history = await GenerationHistoryService.getHistory(type);
    final newHistoryMap =
        Map<String, List<GenerationHistoryItem>>.from(state.historyByType);
    newHistoryMap[type] = history;

    state = state.copyWith(historyByType: newHistoryMap);
  }

  // Add new history item (legacy method for backward compatibility)
  Future<void> addHistoryItem(String value, String type) async {
    if (!state.isHistoryEnabled) return;

    await GenerationHistoryService.addHistoryItem(value, type);
    await loadHistoryForType(type);
  }

  // Add list of items to history using new standardized encoding
  Future<void> addHistoryItems(List<String> items, String type) async {
    if (!state.isHistoryEnabled) return;

    await GenerationHistoryService.addHistoryItems(items, type);
    await loadHistoryForType(type);
  }

  // Delete history item
  Future<void> deleteHistoryItem(String type, int index) async {
    await GenerationHistoryService.deleteHistoryItem(type, index);
    await loadHistoryForType(type);
  }

  // Toggle pin status
  Future<void> togglePinHistoryItem(String type, int index) async {
    await GenerationHistoryService.togglePinHistoryItem(type, index);
    await loadHistoryForType(type);
  }

  // Clear all history for type
  Future<void> clearHistory(String type) async {
    await GenerationHistoryService.clearHistory(type);
    await loadHistoryForType(type);
  }

  // Clear pinned history for type
  Future<void> clearPinnedHistory(String type) async {
    await GenerationHistoryService.clearPinnedHistory(type);
    await loadHistoryForType(type);
  }

  // Clear unpinned history for type
  Future<void> clearUnpinnedHistory(String type) async {
    await GenerationHistoryService.clearUnpinnedHistory(type);
    await loadHistoryForType(type);
  }

  // Set history enabled status
  Future<void> setHistoryEnabled(bool enabled) async {
    await GenerationHistoryService.setHistoryEnabled(enabled);
    state = state.copyWith(isHistoryEnabled: enabled);
  }
}

// Provider for history management
final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>(
  (ref) => HistoryNotifier(),
);

// Specific provider for getting history of a specific type
final historyForTypeProvider =
    Provider.family<List<GenerationHistoryItem>, String>((ref, type) {
  final historyState = ref.watch(historyProvider);
  return historyState.getHistoryForType(type);
});

// Provider for history enabled status
final historyEnabledProvider = Provider<bool>((ref) {
  final historyState = ref.watch(historyProvider);
  return historyState.isHistoryEnabled;
});
