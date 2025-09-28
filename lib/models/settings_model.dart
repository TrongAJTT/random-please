import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 12)
class SettingsModel extends HiveObject {
  @HiveField(0)
  int fetchTimeoutSeconds;

  @HiveField(1)
  bool featureStateSavingEnabled;

  @HiveField(2)
  int logRetentionDays;

  @HiveField(3)
  int fetchRetryTimes;

  @HiveField(4)
  final bool focusModeEnabled;

  @HiveField(5)
  final bool saveRandomToolsState;

  @HiveField(6)
  final bool compactTabLayout;

  @HiveField(7)
  final List<String> remoteListTemplateCustomSource;

  @HiveField(8)
  final bool remoteListTemplateDefaultState;

  @HiveField(9)
  final bool autoScrollToResults;

  @HiveField(10)
  final int? autoCleanupHistoryLimit;

  @HiveField(11)
  final bool resetCounterOnToggle;

  SettingsModel({
    this.fetchTimeoutSeconds = 10,
    this.featureStateSavingEnabled = true, // Always enabled by default
    this.logRetentionDays = 5, // Default to 5 days (minimum in new range)
    this.fetchRetryTimes = 1, // Default to 1 retry
    this.focusModeEnabled = false,
    this.saveRandomToolsState = true,
    this.compactTabLayout = false, // Default to false
    this.remoteListTemplateCustomSource = const [], // Default empty list
    this.remoteListTemplateDefaultState = true, // Default to enabled
    this.autoScrollToResults = true, // Default to enabled
    this.autoCleanupHistoryLimit, // Default to null (No limit)
    this.resetCounterOnToggle = false, // Default to disabled
  });

  SettingsModel copyWith({
    int? fetchTimeoutSeconds,
    bool? featureStateSavingEnabled,
    int? logRetentionDays,
    int? fetchRetryTimes,
    bool? focusModeEnabled,
    bool? saveRandomToolsState,
    bool? compactTabLayout,
    List<String>? remoteListTemplateCustomSource,
    bool? remoteListTemplateDefaultState,
    bool? autoScrollToResults,
    int? autoCleanupHistoryLimit,
    bool? resetCounterOnToggle,
  }) {
    return SettingsModel(
      fetchTimeoutSeconds: fetchTimeoutSeconds ?? this.fetchTimeoutSeconds,
      featureStateSavingEnabled:
          featureStateSavingEnabled ?? this.featureStateSavingEnabled,
      logRetentionDays: logRetentionDays ?? this.logRetentionDays,
      fetchRetryTimes: fetchRetryTimes ?? this.fetchRetryTimes,
      focusModeEnabled: focusModeEnabled ?? this.focusModeEnabled,
      saveRandomToolsState: saveRandomToolsState ?? this.saveRandomToolsState,
      compactTabLayout: compactTabLayout ?? this.compactTabLayout,
      remoteListTemplateCustomSource:
          remoteListTemplateCustomSource ?? this.remoteListTemplateCustomSource,
      remoteListTemplateDefaultState:
          remoteListTemplateDefaultState ?? this.remoteListTemplateDefaultState,
      autoScrollToResults: autoScrollToResults ?? this.autoScrollToResults,
      autoCleanupHistoryLimit:
          autoCleanupHistoryLimit ?? this.autoCleanupHistoryLimit,
      resetCounterOnToggle: resetCounterOnToggle ?? this.resetCounterOnToggle,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fetchTimeoutSeconds': fetchTimeoutSeconds,
      'featureStateSavingEnabled': featureStateSavingEnabled,
      'logRetentionDays': logRetentionDays,
      'fetchRetryTimes': fetchRetryTimes,
      'focusModeEnabled': focusModeEnabled,
      'saveRandomToolsState': saveRandomToolsState,
      'compactTabLayout': compactTabLayout,
      'remoteListTemplateCustomSource': remoteListTemplateCustomSource,
      'remoteListTemplateDefaultState': remoteListTemplateDefaultState,
      'autoScrollToResults': autoScrollToResults,
      'autoCleanupHistoryLimit': autoCleanupHistoryLimit,
      'resetCounterOnToggle': resetCounterOnToggle,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      fetchTimeoutSeconds: json['fetchTimeoutSeconds'] ?? 10,
      featureStateSavingEnabled: json['featureStateSavingEnabled'] ?? true,
      logRetentionDays: json['logRetentionDays'] ?? 5,
      fetchRetryTimes: json['fetchRetryTimes'] ?? 1,
      focusModeEnabled: json['focusModeEnabled'] ?? false,
      saveRandomToolsState: json['saveRandomToolsState'] ?? true,
      compactTabLayout: json['compactTabLayout'] ?? false,
      remoteListTemplateCustomSource:
          List<String>.from(json['remoteListTemplateCustomSource'] ?? []),
      remoteListTemplateDefaultState:
          json['remoteListTemplateDefaultState'] ?? true,
      autoScrollToResults: json['autoScrollToResults'] ?? true,
      autoCleanupHistoryLimit: json['autoCleanupHistoryLimit'],
      resetCounterOnToggle: json['resetCounterOnToggle'] ?? false,
    );
  }
}
