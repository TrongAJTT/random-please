import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/models/list_template_source.dart';
import 'package:random_please/services/list_template_source_service.dart';

// State notifier for managing list template sources
class ListTemplateSourceNotifier
    extends StateNotifier<AsyncValue<List<ListTemplateSource>>> {
  ListTemplateSourceNotifier() : super(const AsyncValue.loading()) {
    _loadSources();
  }

  // Load all sources
  Future<void> _loadSources() async {
    try {
      state = const AsyncValue.loading();
      final sources = ListTemplateSourceService.getAllSources();
      state = AsyncValue.data(sources);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Refresh sources
  Future<void> refresh() async {
    await _loadSources();
  }

  // Get default sources
  List<ListTemplateSource> getDefaultSources() {
    return state.when(
      data: (sources) => sources.where((s) => s.isDefault).toList(),
      loading: () => [],
      error: (_, __) => [],
    );
  }

  // Get custom sources
  List<ListTemplateSource> getCustomSources() {
    return state.when(
      data: (sources) => sources.where((s) => !s.isDefault).toList(),
      loading: () => [],
      error: (_, __) => [],
    );
  }

  // Get sources needing initial fetch
  List<ListTemplateSource> getSourcesNeedingFetch() {
    return state.when(
      data: (sources) => sources
          .where((s) => s.isEnabled && !s.hasData && !s.hasError)
          .toList(),
      loading: () => [],
      error: (_, __) => [],
    );
  }

  // Add custom source
  Future<bool> addCustomSource({
    required String name,
    required String url,
  }) async {
    try {
      await ListTemplateSourceService.addCustomSource(name: name, url: url);
      await _loadSources();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update source
  Future<bool> updateSource(ListTemplateSource source) async {
    try {
      await ListTemplateSourceService.updateSource(source);
      await _loadSources();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete source
  Future<bool> deleteSource(ListTemplateSource source) async {
    try {
      await ListTemplateSourceService.deleteSource(source);
      await _loadSources();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Toggle source enabled/disabled
  Future<bool> toggleSourceEnabled(ListTemplateSource source) async {
    try {
      source.isEnabled = !source.isEnabled;
      await source.save();
      await _loadSources();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Reset to default
  Future<bool> resetToDefault() async {
    try {
      await ListTemplateSourceService.resetToDefault();
      await _loadSources();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Fetch data from a source
  Future<FetchResult> fetchSourceData(ListTemplateSource source) async {
    try {
      final result = await ListTemplateSourceService.fetchSourceData(source);
      await _loadSources(); // Refresh to show updated data
      return result;
    } catch (e) {
      return FetchResult.error(e.toString());
    }
  }

  // Fetch data from multiple sources
  Future<Map<ListTemplateSource, FetchResult>> fetchMultipleSources(
    List<ListTemplateSource> sources,
  ) async {
    try {
      final results =
          await ListTemplateSourceService.fetchMultipleSources(sources);
      await _loadSources(); // Refresh to show updated data
      return results;
    } catch (e) {
      return {};
    }
  }
}

// Provider for list template sources
final listTemplateSourceProvider = StateNotifierProvider<
    ListTemplateSourceNotifier, AsyncValue<List<ListTemplateSource>>>(
  (ref) => ListTemplateSourceNotifier(),
);

// Helper providers for specific source types
final defaultSourcesProvider = Provider<List<ListTemplateSource>>((ref) {
  final sourcesAsync = ref.watch(listTemplateSourceProvider);
  return sourcesAsync.when(
    data: (sources) => sources.where((s) => s.isDefault).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final customSourcesProvider = Provider<List<ListTemplateSource>>((ref) {
  final sourcesAsync = ref.watch(listTemplateSourceProvider);
  return sourcesAsync.when(
    data: (sources) => sources.where((s) => !s.isDefault).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final sourcesNeedingFetchProvider = Provider<List<ListTemplateSource>>((ref) {
  final sourcesAsync = ref.watch(listTemplateSourceProvider);
  return sourcesAsync.when(
    data: (sources) =>
        sources.where((s) => s.isEnabled && !s.hasData && !s.hasError).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

final enabledSourcesProvider = Provider<List<ListTemplateSource>>((ref) {
  final sourcesAsync = ref.watch(listTemplateSourceProvider);
  return sourcesAsync.when(
    data: (sources) => sources.where((s) => s.isEnabled).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});
