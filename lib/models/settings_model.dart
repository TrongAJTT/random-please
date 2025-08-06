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

  SettingsModel({
    this.fetchTimeoutSeconds = 10,
    this.featureStateSavingEnabled = true, // Always enabled by default
    this.logRetentionDays = 5, // Default to 5 days (minimum in new range)
    this.fetchRetryTimes = 1, // Default to 1 retry
    this.focusModeEnabled = false,
    this.saveRandomToolsState = true,
  });

  SettingsModel copyWith({
    int? fetchTimeoutSeconds,
    bool? featureStateSavingEnabled,
    int? logRetentionDays,
    int? fetchRetryTimes,
    bool? focusModeEnabled,
    bool? saveRandomToolsState,
  }) {
    return SettingsModel(
      fetchTimeoutSeconds: fetchTimeoutSeconds ?? this.fetchTimeoutSeconds,
      featureStateSavingEnabled:
          featureStateSavingEnabled ?? this.featureStateSavingEnabled,
      logRetentionDays: logRetentionDays ?? this.logRetentionDays,
      fetchRetryTimes: fetchRetryTimes ?? this.fetchRetryTimes,
      focusModeEnabled: focusModeEnabled ?? this.focusModeEnabled,
      saveRandomToolsState: saveRandomToolsState ?? this.saveRandomToolsState,
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
    );
  }
}
