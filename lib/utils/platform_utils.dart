import 'dart:io';

import 'package:flutter/material.dart';
import 'package:random_please/services/version_check_service.dart';

class PlatformUtils {
  /// Platform names
  static const String platformAndroid = 'Android';
  static const String platformWindows = 'Windows';
  static const String platformMacOS = 'macOS';
  static const String platformLinux = 'Linux';
  static const String platformIOS = 'iOS';
  static const String platformOther = 'Other';

  /// List of all platform names
  static List<String> get platformList => [
        platformAndroid,
        platformWindows,
        platformMacOS,
        platformLinux,
        platformIOS,
      ];

  // Get the platform name based on the current platform.
  static String getPlatformName() {
    if (Platform.isAndroid) return platformAndroid;
    if (Platform.isWindows) return platformWindows;
    if (Platform.isMacOS) return platformMacOS;
    if (Platform.isLinux) return platformLinux;
    if (Platform.isIOS) return platformIOS;
    return platformOther;
  }

  // Get the platform icon based on the current platform.
  static List<ReleaseAsset> filterAssetsByPlatform(List<ReleaseAsset> assets) {
    return assets
        .where((asset) =>
            asset.name.toLowerCase().contains(getPlatformName().toLowerCase()))
        .toList();
  }

  /// Get the platform name from a file name.
  static String getPlatformNameFromFileName(String fileName) {
    for (final platform in platformList) {
      if (fileName.toLowerCase().contains(platform.toLowerCase())) {
        return platform;
      }
    }
    return platformOther;
  }

  /// Get the platform name from a release asset.
  static String getPlatformNameFromAsset(ReleaseAsset asset) {
    return getPlatformNameFromFileName(asset.name);
  }

  /// Group assets by platform.
  static Map<String, List<ReleaseAsset>> groupAssetsByPlatform(
      List<ReleaseAsset> assets) {
    final Map<String, List<ReleaseAsset>> groups = {};

    for (final asset in assets) {
      final platform = getPlatformNameFromAsset(asset);
      if (!groups.containsKey(platform)) {
        groups[platform] = [];
      }
      groups[platform]!.add(asset);
    }

    return groups;
  }

  /// Get the platform-specific icon from a file name.
  static IconData getPlatformIconFromFileName(String fileName) {
    final platform = getPlatformNameFromFileName(fileName);
    return getPlatformIcon(platform);
  }

  /// Get the platform-specific icon for the given platform.
  static IconData getPlatformIcon(String platform) {
    switch (platform) {
      case platformAndroid:
        return Icons.android;
      case platformWindows:
        return Icons.computer;
      case platformMacOS:
        return Icons.laptop_mac;
      case platformLinux:
        return Icons.desktop_windows;
      case platformIOS:
        return Icons.phone_iphone;
      default:
        return Icons.devices_other;
    }
  }

  /// Get the platform-specific color for the given platform.
  static Color getPlatformColor(String platform) {
    switch (platform) {
      case platformAndroid:
        return Colors.green;
      case platformWindows:
        return Colors.blue;
      case platformMacOS:
        return Colors.grey;
      case platformLinux:
        return Colors.orange;
      case platformIOS:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
