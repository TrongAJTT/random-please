import 'dart:convert';
import 'dart:io';
import 'package:random_please/models/tool_config.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tool_visibility_service.dart';

// Import quick_actions but use it safely with platform checks
import 'package:quick_actions/quick_actions.dart';

/// Service for managing quick actions on Android and iOS only
/// Quick actions are shortcuts that appear when long-pressing the app icon (Android)
/// or using 3D Touch/Haptic Touch (iOS)
class QuickActionsService {
  static const String _quickActionsKey = 'quick_actions_enabled';
  static const int _maxQuickActions = 4;
  // Maximum number of quick actions allowed  /// Initialize quick actions on app startup
  static Future<void> initialize() async {
    // Quick actions only supported on Android and iOS
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    try {
      const quickActions = QuickActions();
      final enabledActions = await getEnabledQuickActions();

      if (enabledActions.isNotEmpty) {
        await _updatePlatformQuickActions(quickActions, enabledActions);
      }
    } catch (e) {
      // Silently handle any platform-specific errors
      // This prevents crashes on unsupported platforms
      logFatal('Quick actions initialization failed: $e');
    }
  }

  /// Get list of tools that have quick actions enabled
  static Future<List<ToolConfig>> getEnabledQuickActions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_quickActionsKey);

    if (jsonString == null) {
      return [];
    }
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<String> enabledIds = jsonList.cast<String>();
      final allTools = await ToolVisibilityService.getAllToolsInOrder();

      // Return tools in the same order as saved, filtered by enabled IDs
      return enabledIds
          .map((id) => allTools.firstWhere((tool) => tool.id == id,
              orElse: () => ToolConfig.empty()))
          .where((tool) => tool.id.isNotEmpty)
          .toList();
    } catch (e) {
      // Return empty list if parsing fails
      return [];
    }
  }

  /// Save list of tools that should have quick actions enabled
  /// Maximum 4 tools allowed
  static Future<void> saveEnabledQuickActions(List<ToolConfig> tools) async {
    // Enforce maximum limit
    final limitedTools = tools.take(_maxQuickActions).toList();

    final prefs = await SharedPreferences.getInstance();
    final enabledIds = limitedTools.map((tool) => tool.id).toList();
    final jsonString = json.encode(enabledIds);

    await prefs.setString(_quickActionsKey, jsonString);

    // Update platform quick actions only on supported platforms
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        const quickActions = QuickActions();
        await _updatePlatformQuickActions(quickActions, limitedTools);
      } catch (e) {
        // Silently handle any platform-specific errors
        logError('Quick actions update failed: $e');
      }
    }
  }

  /// Update platform-specific quick actions
  static Future<void> _updatePlatformQuickActions(
      QuickActions quickActions, List<ToolConfig> tools) async {
    final shortcutItems = tools
        .map((tool) => ShortcutItem(
              type: tool.id,
              localizedTitle: tool.fixName,
              icon: tool.quickActionIcon,
            ))
        .toList();

    await quickActions.setShortcutItems(shortcutItems);
  }

  /// Set up quick action handler to navigate to specific tools
  static void setQuickActionHandler(
      Function(String toolId) onQuickActionSelected) {
    // Only set up handler on supported platforms
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    try {
      const quickActions = QuickActions();
      quickActions.initialize(onQuickActionSelected);
    } catch (e) {
      // Silently handle any platform-specific errors
      logError('Quick actions handler setup failed: $e');
    }
  }

  /// Check if a tool has quick action enabled
  static Future<bool> isQuickActionEnabled(String toolId) async {
    final enabledActions = await getEnabledQuickActions();
    return enabledActions.any((tool) => tool.id == toolId);
  }

  /// Toggle quick action for a specific tool
  static Future<void> toggleQuickAction(ToolConfig tool) async {
    final enabledActions = await getEnabledQuickActions();
    final isCurrentlyEnabled = enabledActions.any((t) => t.id == tool.id);

    if (isCurrentlyEnabled) {
      // Remove from enabled list
      enabledActions.removeWhere((t) => t.id == tool.id);
    } else {
      // Add to enabled list if under limit
      if (enabledActions.length < _maxQuickActions) {
        enabledActions.add(tool);
      } else {
        throw Exception('Maximum of $_maxQuickActions quick actions allowed');
      }
    }

    await saveEnabledQuickActions(enabledActions);
  }

  /// Get maximum number of quick actions allowed
  static int get maxQuickActions => _maxQuickActions;

  /// Clear all quick actions
  static Future<void> clearAllQuickActions() async {
    await saveEnabledQuickActions([]);
  }
}
