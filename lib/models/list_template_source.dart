import 'package:hive/hive.dart';
import 'package:random_please/models/cloud_template.dart';

part 'list_template_source.g.dart';

@HiveType(typeId: 13)
class ListTemplateSource extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String url;

  @HiveField(2)
  bool isDefault;

  @HiveField(3)
  bool isEnabled;

  @HiveField(4)
  List<CloudTemplate>? fetchedData;

  @HiveField(5)
  DateTime? lastFetchDate;

  @HiveField(6)
  String? lastError;

  ListTemplateSource({
    required this.name,
    required this.url,
    this.isDefault = false,
    this.isEnabled = true,
    this.fetchedData,
    this.lastFetchDate,
    this.lastError,
  });

  // Copy with method
  ListTemplateSource copyWith({
    String? name,
    String? url,
    bool? isDefault,
    bool? isEnabled,
    List<CloudTemplate>? fetchedData,
    DateTime? lastFetchDate,
    String? lastError,
  }) {
    return ListTemplateSource(
      name: name ?? this.name,
      url: url ?? this.url,
      isDefault: isDefault ?? this.isDefault,
      isEnabled: isEnabled ?? this.isEnabled,
      fetchedData: fetchedData ?? this.fetchedData,
      lastFetchDate: lastFetchDate ?? this.lastFetchDate,
      lastError: lastError ?? this.lastError,
    );
  }

  // Utility methods
  bool get hasData => fetchedData != null && fetchedData!.isNotEmpty;

  bool get hasError => lastError != null && lastError!.isNotEmpty;

  int get totalTemplates => fetchedData?.length ?? 0;

  Map<String, int> get languageStats {
    if (fetchedData == null) return {};

    final stats = <String, int>{};
    for (final template in fetchedData!) {
      stats[template.lang] =
          (stats[template.lang] ?? 0) + template.values.length;
    }
    return stats;
  }

  String get statusDescription {
    if (hasError) return 'Error: $lastError';
    if (!hasData) return 'No data fetched';

    final stats = languageStats;
    final languages = stats.keys.toList()..sort();
    final descriptions =
        languages.map((lang) => '$lang: ${stats[lang]} items').join(', ');

    return '$totalTemplates templates ($descriptions)';
  }

  String get lastFetchDescription {
    if (lastFetchDate == null) return 'Never fetched';

    final now = DateTime.now();
    final difference = now.difference(lastFetchDate!);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // Convert to/from JSON for debugging
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'isDefault': isDefault,
      'isEnabled': isEnabled,
      'fetchedData': fetchedData?.map((e) => e.toJson()).toList(),
      'lastFetchDate': lastFetchDate?.toIso8601String(),
      'lastError': lastError,
    };
  }

  factory ListTemplateSource.fromJson(Map<String, dynamic> json) {
    return ListTemplateSource(
      name: json['name'] as String,
      url: json['url'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      isEnabled: json['isEnabled'] as bool? ?? true,
      fetchedData: json['fetchedData'] != null
          ? (json['fetchedData'] as List)
              .map((e) => CloudTemplate.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      lastFetchDate: json['lastFetchDate'] != null
          ? DateTime.parse(json['lastFetchDate'] as String)
          : null,
      lastError: json['lastError'] as String?,
    );
  }

  @override
  String toString() {
    return 'ListTemplateSource(name: $name, url: $url, isDefault: $isDefault, isEnabled: $isEnabled, hasData: $hasData, lastFetch: $lastFetchDescription)';
  }
}
