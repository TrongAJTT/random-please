import 'package:flutter/foundation.dart';

// Platform detection service theo SOLID SRP principle
class PlatformService {
  // Singleton pattern
  static final PlatformService _instance = PlatformService._internal();
  factory PlatformService() => _instance;
  PlatformService._internal();

  /// Check if current platform supports local API server
  bool get supportsLocalApi {
    // Web không support local API vì security restrictions
    if (kIsWeb) return false;

    // Native platforms (Windows, Android, iOS, macOS, Linux) support
    return true;
  }

  /// Get current platform name
  String get platformName {
    if (kIsWeb) return 'web';

    // In a real app, you might want to use dart:io Platform.operatingSystem
    // But we use foundation.dart to avoid conditional imports
    return 'native';
  }

  /// Check if platform is web
  bool get isWeb => kIsWeb;

  /// Check if platform is native (desktop or mobile)
  bool get isNative => !kIsWeb;

  /// Get platform-specific configurations
  Map<String, dynamic> getPlatformConfig() {
    return {
      'platform': platformName,
      'supportsLocalApi': supportsLocalApi,
      'isWeb': isWeb,
      'isNative': isNative,
    };
  }
}
