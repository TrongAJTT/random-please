import 'dart:typed_data';
import 'package:flutter/material.dart';
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
  Future<bool> handleAppLaunch(BuildContext context) async {
    await initialize();
    
    if (!_isSecurityEnabled) {
      // Check if we need to show setup dialog
      if (await needsSecuritySetup()) {
        final setupResult = await SecurityDialogs.handleSecuritySetup(context);
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
      return await authenticate(context);
    }
  }

  /// Authenticate user with master password
  Future<bool> authenticate(BuildContext context) async {
    if (!_isSecurityEnabled) {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    final password = await SecurityDialogs.handleSecurityLogin(context);
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
  Future<bool> enableSecurity(BuildContext context, String masterPassword) async {
    final success = await SecurityService.enableSecurity(masterPassword);
    if (success) {
      // Migrate existing data
      await DataMigrationService.migrateToEncrypted(masterPassword);
      
      // Update state
      _isSecurityEnabled = true;
      _isAuthenticated = true;
      _currentMasterPassword = masterPassword;
      _currentEncryptionKey = await SecurityService.getEncryptionKey(masterPassword);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Disable security
  Future<bool> disableSecurity(String currentPassword) async {
    // Verify current password first
    final isValid = await SecurityService.verifyPassword(currentPassword);
    if (!isValid) {
      return false;
    }

    // Migrate data back to unencrypted
    final migrationSuccess = await DataMigrationService.migrateToUnencrypted(currentPassword);
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

  /// Get migration status
  Future<Map<String, dynamic>> getMigrationStatus() async {
    return await DataMigrationService.getMigrationStatus();
  }
}
