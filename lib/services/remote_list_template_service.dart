import 'package:random_please/services/settings_service.dart';
import 'package:random_please/variables.dart';

class RemoteListTemplateService {
  static Future<List<String>> getCustomSources() async {
    final settings = await SettingsService.getSettings();
    return settings.remoteListTemplateCustomSource;
  }

  static Future<bool> getDefaultSourceState() async {
    final settings = await SettingsService.getSettings();
    return settings.remoteListTemplateDefaultState;
  }

  static Future<void> updateCustomSources(List<String> sources) async {
    final settings = await SettingsService.getSettings();
    final updatedSettings = settings.copyWith(
      remoteListTemplateCustomSource: sources,
    );
    await SettingsService.saveSettings(updatedSettings);
  }

  static Future<void> updateDefaultSourceState(bool enabled) async {
    final settings = await SettingsService.getSettings();
    final updatedSettings = settings.copyWith(
      remoteListTemplateDefaultState: enabled,
    );
    await SettingsService.saveSettings(updatedSettings);
  }

  static Future<void> resetToDefault() async {
    final settings = await SettingsService.getSettings();
    final updatedSettings = settings.copyWith(
      remoteListTemplateCustomSource: [],
      remoteListTemplateDefaultState: true,
    );
    await SettingsService.saveSettings(updatedSettings);
  }

  /// Get all active sources (default + custom visible sources)
  static Future<List<String>> getActiveSources() async {
    final List<String> activeSources = [];

    // Add default source if enabled
    final defaultEnabled = await getDefaultSourceState();
    if (defaultEnabled) {
      activeSources.add(authorCloudListEndpoint);
    }

    // Add visible custom sources (sources without - prefix)
    final customSources = await getCustomSources();
    for (final source in customSources) {
      if (!source.startsWith('-')) {
        activeSources.add(source);
      }
    }

    return activeSources;
  }

  /// Get all sources with their visibility state
  static Future<List<RemoteListTemplateItem>> getAllSourcesWithState() async {
    final List<RemoteListTemplateItem> items = [];

    // Add default source
    final defaultEnabled = await getDefaultSourceState();
    items.add(RemoteListTemplateItem(
      url: authorCloudListEndpoint,
      isVisible: defaultEnabled,
      isDefault: true,
    ));

    // Add custom sources
    final customSources = await getCustomSources();
    for (final source in customSources) {
      final isVisible = !source.startsWith('-');
      final url =
          isVisible ? source : source.substring(1); // Remove - prefix if hidden
      items.add(RemoteListTemplateItem(
        url: url,
        isVisible: isVisible,
        isDefault: false,
      ));
    }

    return items;
  }

  /// Save sources with their visibility state
  static Future<void> saveSourcesWithState(
      List<RemoteListTemplateItem> items) async {
    // Update default source state
    final defaultItem = items.firstWhere((item) => item.isDefault);
    await updateDefaultSourceState(defaultItem.isVisible);

    // Update custom sources with visibility prefix
    final customSources = items
        .where((item) => !item.isDefault)
        .map((item) => item.isVisible ? item.url : '-${item.url}')
        .toList();

    await updateCustomSources(customSources);
  }
}

class RemoteListTemplateItem {
  final String url;
  final bool isVisible;
  final bool isDefault;

  const RemoteListTemplateItem({
    required this.url,
    required this.isVisible,
    required this.isDefault,
  });

  RemoteListTemplateItem copyWith({
    String? url,
    bool? isVisible,
    bool? isDefault,
  }) {
    return RemoteListTemplateItem(
      url: url ?? this.url,
      isVisible: isVisible ?? this.isVisible,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
