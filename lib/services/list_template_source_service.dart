import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:random_please/models/list_template_source.dart';
import 'package:random_please/models/cloud_template.dart';

import 'package:random_please/services/app_logger.dart';
import 'package:random_please/variables.dart';

class ListTemplateSourceService {
  static const String _boxName = 'list_template_sources';
  static Box<ListTemplateSource>? _box;

  // Initialize the service
  static Future<void> init() async {
    _box = await Hive.openBox<ListTemplateSource>(_boxName);

    // Initialize default sources if empty
    if (_box!.isEmpty) {
      await _initializeDefaultSources();
    }
  }

  // Get the box instance
  static Box<ListTemplateSource> get box {
    if (_box == null) {
      throw StateError(
          'ListTemplateSourceService not initialized. Call init() first.');
    }
    return _box!;
  }

  // Initialize default sources from variables
  static Future<void> _initializeDefaultSources() async {
    AppLogger.instance.info('Initializing default list template sources');

    try {
      // Fetch the index to get the list of available templates
      final response = await http.get(
        Uri.parse(authorCloudListEndpoint),
        headers: {'User-Agent': userAgent},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is Map<String, dynamic> && jsonData['success'] == true) {
          final data = jsonData['data'] as List<dynamic>? ?? [];

          // Create a source for each template in the index
          for (final item in data) {
            if (item is Map<String, dynamic>) {
              final name = item['name'] as String? ?? 'Unknown Template';
              final file = item['file'] as String? ?? '';
              // final description = item['description'] as String? ?? '';

              if (file.isNotEmpty) {
                final templateUrl = '$authorCloudListRoute/$file';

                final source = ListTemplateSource(
                  name: name,
                  url: templateUrl,
                  isDefault: true,
                  isEnabled: true,
                );

                await box.add(source);
                AppLogger.instance.info(
                    'Added default template source: $name - $templateUrl');
              }
            }
          }

          AppLogger.instance.info(
              'Successfully initialized ${data.length} default template sources');
        } else {
          throw const FormatException(
              'Invalid response format from index endpoint');
        }
      } else {
        throw HttpException('Failed to fetch index: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.instance.error('Failed to initialize default sources: $e');

      // Fallback: create a basic source if index fetch fails
      final fallbackSource = ListTemplateSource(
        name: 'Default Template Source',
        url: authorCloudListEndpoint,
        isDefault: true,
        isEnabled: true,
      );

      await box.add(fallbackSource);
      AppLogger.instance.info('Added fallback default source');
    }
  }

  // Get all sources
  static List<ListTemplateSource> getAllSources() {
    return box.values.toList();
  }

  // Get all default sources
  static List<ListTemplateSource> getDefaultSources() {
    return box.values.where((source) => source.isDefault).toList();
  }

  // Get all custom sources
  static List<ListTemplateSource> getCustomSources() {
    return box.values.where((source) => !source.isDefault).toList();
  }

  // Get all enabled sources
  static List<ListTemplateSource> getEnabledSources() {
    return box.values.where((source) => source.isEnabled).toList();
  }

  // Get sources that need initial fetch (no data and no error)
  static List<ListTemplateSource> getSourcesNeedingInitialFetch() {
    return box.values
        .where(
            (source) => source.isEnabled && !source.hasData && !source.hasError)
        .toList();
  }

  // Add a new custom source
  static Future<ListTemplateSource> addCustomSource({
    required String name,
    required String url,
  }) async {
    final source = ListTemplateSource(
      name: name,
      url: url,
      isDefault: false,
      isEnabled: true,
    );

    await box.add(source);
    AppLogger.instance
        .info('Added custom source: ${source.name} - ${source.url}');
    return source;
  }

  // Update an existing source
  static Future<void> updateSource(ListTemplateSource source) async {
    await source.save();
    AppLogger.instance.info('Updated source: ${source.name}');
  }

  // Delete a source (only custom sources)
  static Future<void> deleteSource(ListTemplateSource source) async {
    if (source.isDefault) {
      throw ArgumentError('Cannot delete default sources');
    }

    await source.delete();
    AppLogger.instance.info('Deleted custom source: ${source.name}');
  }

  // Refresh default sources from remote index
  static Future<void> refreshDefaultSources() async {
    AppLogger.instance.info('Refreshing default list template sources');

    try {
      // Fetch the latest index
      final response = await http.get(
        Uri.parse(authorCloudListEndpoint),
        headers: {'User-Agent': userAgent},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is Map<String, dynamic> && jsonData['success'] == true) {
          final data = jsonData['data'] as List<dynamic>? ?? [];

          final existingDefaults = getDefaultSources();

          // Add new templates or update existing ones
          for (final item in data) {
            if (item is Map<String, dynamic>) {
              final name = item['name'] as String? ?? 'Unknown Template';
              final file = item['file'] as String? ?? '';

              if (file.isNotEmpty) {
                final templateUrl = '$authorCloudListRoute/$file';

                // Check if this URL already exists
                final existingSource = existingDefaults
                    .where((s) => s.url == templateUrl)
                    .firstOrNull;

                if (existingSource != null) {
                  // Update existing source name if needed
                  if (existingSource.name != name) {
                    existingSource.name = name;
                    await existingSource.save();
                    AppLogger.instance.info('Updated default source: $name');
                  }
                } else {
                  // Add new default source
                  final source = ListTemplateSource(
                    name: name,
                    url: templateUrl,
                    isDefault: true,
                    isEnabled: true,
                  );

                  await box.add(source);
                  AppLogger.instance
                      .info('Added new default source: $name - $templateUrl');
                }
              }
            }
          }

          AppLogger.instance
              .info('Successfully refreshed default template sources');
        } else {
          throw const FormatException(
              'Invalid response format from index endpoint');
        }
      } else {
        throw HttpException('Failed to fetch index: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.instance.error('Failed to refresh default sources: $e');
      rethrow;
    }
  }

  // Reset all sources to default
  static Future<void> resetToDefault() async {
    // Delete all sources
    await box.clear();

    // Re-initialize default sources
    await _initializeDefaultSources();

    AppLogger.instance.info('Reset all sources to default');
  }

  // Fetch data from a template source
  static Future<FetchResult> fetchSourceData(ListTemplateSource source) async {
    return await _fetchTemplateData(source);
  }

  // Fetch template data
  static Future<FetchResult> _fetchTemplateData(
      ListTemplateSource source) async {
    AppLogger.instance
        .info('Fetching template data from: ${source.name} - ${source.url}');

    try {
      final response = await http.get(
        Uri.parse(source.url),
        headers: {'User-Agent': userAgent},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is! List) {
          throw FormatException(
              'Expected JSON array, got ${jsonData.runtimeType}');
        }

        final templates = <CloudTemplate>[];
        for (final item in jsonData) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Invalid template format');
          }
          templates.add(CloudTemplate.fromJson(item));
        }

        // Update the source with fetched data
        source.fetchedData = templates;
        source.lastFetchDate = DateTime.now();
        source.lastError = null;
        await source.save();

        AppLogger.instance.info(
            'Successfully fetched ${templates.length} templates from ${source.name}');
        return FetchResult.success(templates);
      } else {
        final errorMsg =
            'HTTP ${response.statusCode}: ${response.reasonPhrase}';
        source.lastError = errorMsg;
        source.lastFetchDate = DateTime.now();
        await source.save();

        AppLogger.instance.warning(
            'Failed to fetch templates from ${source.name}: $errorMsg');
        return FetchResult.error(errorMsg);
      }
    } catch (e) {
      final errorMsg = e.toString();
      source.lastError = errorMsg;
      source.lastFetchDate = DateTime.now();
      await source.save();

      AppLogger.instance
          .error('Error fetching templates from ${source.name}: $errorMsg');
      return FetchResult.error(errorMsg);
    }
  }

  // Fetch data from URL without requiring Hive object
  static Future<FetchResult> fetchFromUrl({
    required String url,
    required String sourceName,
  }) async {
    AppLogger.instance.info('Fetching data from URL: $sourceName - $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': userAgent},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is! List) {
          throw FormatException(
              'Expected JSON array, got ${jsonData.runtimeType}');
        }

        final templates = <CloudTemplate>[];
        for (final item in jsonData) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Invalid template format');
          }
          templates.add(CloudTemplate.fromJson(item));
        }

        AppLogger.instance.info(
            'Successfully fetched ${templates.length} templates from $sourceName');
        return FetchResult.success(templates);
      } else {
        final errorMsg =
            'HTTP ${response.statusCode}: ${response.reasonPhrase}';
        AppLogger.instance
            .warning('Failed to fetch from $sourceName: $errorMsg');
        return FetchResult.error(errorMsg);
      }
    } catch (e) {
      final errorMsg = e.toString();
      AppLogger.instance.error('Error fetching from $sourceName: $errorMsg');
      return FetchResult.error(errorMsg);
    }
  }

  // Fetch data from multiple sources
  static Future<Map<ListTemplateSource, FetchResult>> fetchMultipleSources(
      List<ListTemplateSource> sources) async {
    final results = <ListTemplateSource, FetchResult>{};

    for (final source in sources) {
      results[source] = await fetchSourceData(source);
    }

    return results;
  }
}

// Result class for fetch operations
class FetchResult {
  final bool isSuccess;
  final List<CloudTemplate>? templates;
  final String? error;

  const FetchResult._({
    required this.isSuccess,
    this.templates,
    this.error,
  });

  factory FetchResult.success(List<CloudTemplate> templates) {
    return FetchResult._(
      isSuccess: true,
      templates: templates,
    );
  }

  factory FetchResult.error(String error) {
    return FetchResult._(
      isSuccess: false,
      error: error,
    );
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'FetchResult.success(${templates?.length} templates)';
    } else {
      return 'FetchResult.error($error)';
    }
  }
}
