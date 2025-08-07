import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/services/security_service.dart';
import 'package:random_please/services/data_migration_service.dart';
import 'package:random_please/widgets/security/security_dialogs.dart';

class SecurityManager extends ChangeNotifier {
  static SecurityManager? _instance;
  static SecurityManager get instance => _instance ??= SecurityManager._();

  SecurityManager._();

  bool _isSecurityEnabled = false;
  bool _isAuthenticated = false;
  String? _currentMasterPassword;
  Uint8List? _currentEncryptionKey;
  bool _isInitialized = false;

  bool get isSecurityEnabled => _isSecurityEnabled;
  bool get isAuthenticated => _isAuthenticated;
  bool get isInitialized => _isInitialized;
  String? get currentMasterPassword => _currentMasterPassword;
  Uint8List? get currentEncryptionKey => _currentEncryptionKey;

  /// Initialize security manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isSecurityEnabled = await SecurityService.isSecurityEnabled();
    _isInitialized = true;
    notifyListeners();
  }

  /// Check if app needs security setup on first launch
  Future<bool> needsSecuritySetup() async {
    await initialize();

    // Only show setup if:
    // 1. Security is not enabled
    // 2. We haven't shown the setup dialog before
    if (!_isSecurityEnabled) {
      final hasShown = await SecurityService.hasShownSecuritySetup();
      return !hasShown;
    }

    return false;
  }

  /// Handle app launch security flow
  Future<bool> handleAppLaunch(
      BuildContext context, AppLocalizations loc) async {
    await initialize();

    if (!_isSecurityEnabled) {
      // Check if we need to show setup dialog
      if (await needsSecuritySetup()) {
        final setupResult =
            await SecurityDialogs.handleSecuritySetup(context, loc);
        if (setupResult) {
          await initialize(); // Re-initialize after setup
          notifyListeners(); // Notify UI about state change
        }
      }

      // If still no security, user can proceed
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } else {
      // Security is enabled, need to authenticate
      return await authenticate(context, loc);
    }
  }

  /// Authenticate user with master password
  Future<bool> authenticate(BuildContext context, AppLocalizations loc) async {
    if (!_isSecurityEnabled) {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    final password = await SecurityDialogs.handleSecurityLogin(context, loc);
    if (password == null) {
      // User reset data, security is now disabled
      await initialize();
      _isAuthenticated = true;
      _currentMasterPassword = null;
      _currentEncryptionKey = null;
      notifyListeners();
      return true;
    }

    // Get encryption key for this session
    _currentEncryptionKey = await SecurityService.getEncryptionKey(password);
    if (_currentEncryptionKey != null) {
      _isAuthenticated = true;
      _currentMasterPassword = password;
      notifyListeners();
      return true;
    }

    return false;
  }

  /// Enable security with master password
  Future<bool> enableSecurity(
      BuildContext context, String masterPassword) async {
    try {
      print('SecurityManager.enableSecurity: Starting...');
      final success = await SecurityService.enableSecurity(masterPassword);
      print(
          'SecurityManager.enableSecurity: SecurityService.enableSecurity result: $success');

      if (success) {
        print('SecurityManager.enableSecurity: Starting data migration...');
        // Migrate existing data
        await DataMigrationService.migrateToEncrypted(masterPassword);
        print('SecurityManager.enableSecurity: Data migration completed');

        // Update state
        _isSecurityEnabled = true;
        _isAuthenticated = true;
        _currentMasterPassword = masterPassword;
        _currentEncryptionKey =
            await SecurityService.getEncryptionKey(masterPassword);
        notifyListeners();
        print('SecurityManager.enableSecurity: State updated and notified');
        return true;
      }
      print(
          'SecurityManager.enableSecurity: SecurityService.enableSecurity failed');
      return false;
    } catch (e) {
      print('SecurityManager.enableSecurity: Exception caught: $e');
      // If anything fails, make sure security is disabled
      try {
        await SecurityService.disableSecurity();
      } catch (e) {
        // Ignore cleanup errors
      }
      rethrow;
    }
  }

  /// Disable security
  Future<bool> disableSecurity(String currentPassword) async {
    try {
      // Verify current password first
      final isValid = await SecurityService.verifyPassword(currentPassword);
      if (!isValid) {
        return false;
      }

      // Migrate data back to unencrypted
      final migrationSuccess =
          await DataMigrationService.migrateToUnencrypted(currentPassword);
      if (!migrationSuccess) {
        return false;
      }

      // Disable security
      final success = await SecurityService.disableSecurity();
      if (success) {
        _isSecurityEnabled = false;
        _isAuthenticated = true; // Still authenticated, just no security
        _currentMasterPassword = null;
        _currentEncryptionKey = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      // If anything fails during disable, we're in an inconsistent state
      rethrow;
    }
  }

  /// Lock the app (require authentication again)
  void lock() {
    _isAuthenticated = false;
    _currentMasterPassword = null;
    _currentEncryptionKey = null;
    notifyListeners();
  }

  /// Reset all security (for emergency use)
  Future<void> resetAll() async {
    await DataMigrationService.clearEncryptedData();
    await SecurityService.resetSecurity();

    _isSecurityEnabled = false;
    _isAuthenticated = true;
    _currentMasterPassword = null;
    _currentEncryptionKey = null;
    _isInitialized = false;

    notifyListeners();
  }

  /// Update state after security setup (called from SecurityDialogs)
  Future<void> updateAfterSetup(String password) async {
    await initialize();
    _isAuthenticated = true;
    _currentMasterPassword = password;
    _currentEncryptionKey = await SecurityService.getEncryptionKey(password);
    notifyListeners();
  }

  /// Get migration status
  Future<Map<String, dynamic>> getMigrationStatus() async {
    return await DataMigrationService.getMigrationStatus();
  }
}
