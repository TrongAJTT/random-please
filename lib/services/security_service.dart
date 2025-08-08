import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_please/services/app_logger.dart';
import 'package:flutter/foundation.dart';

class SecurityService {
  static const String _saltKey = 'app_security_salt';
  static const String _isSecurityEnabledKey = 'is_security_enabled';
  static const String _encryptedDataTestKey = 'encrypted_data_test';
  static const String _hasShownSecuritySetupKey = 'has_shown_security_setup';

  // PBKDF2 parameters - different for web and native for performance
  static int get _iterations {
    if (kDebugMode && kIsWeb) {
      return 1000; // Very fast for web debug
    } else if (kIsWeb) {
      return 30000; // 30k for web release
    } else {
      return 100000; // 100k for native
    }
  }

  static const int _keyLength = 32; // 256 bits
  static const int _saltLength = 32; // 256 bits

  /// Generate a random salt
  static Uint8List _generateSalt() {
    final random = Random.secure();
    final salt = Uint8List(_saltLength);
    for (int i = 0; i < _saltLength; i++) {
      salt[i] = random.nextInt(256);
    }
    return salt;
  }

  /// Derive encryption key from password using PBKDF2
  static Uint8List _deriveKey(String password, Uint8List salt) {
    final stopwatch = Stopwatch()..start();
    final passwordBytes = utf8.encode(password);

    logInfo(
        'SecurityService: Starting PBKDF2 with $_iterations iterations (${kIsWeb ? 'web' : 'native'})');

    // PBKDF2 implementation
    final hmac = Hmac(sha256, passwordBytes);
    final derivedKey = Uint8List(_keyLength);

    for (int i = 1; i <= (_keyLength / 32).ceil(); i++) {
      final block = _pbkdf2Block(hmac, salt, _iterations, i);
      final start = (i - 1) * 32;
      final end = (start + 32 > _keyLength) ? _keyLength : start + 32;
      derivedKey.setRange(start, end, block);
    }

    stopwatch.stop();
    logInfo(
        'SecurityService: PBKDF2 completed in ${stopwatch.elapsedMilliseconds}ms');

    return derivedKey;
  }

  /// PBKDF2 block generation
  static Uint8List _pbkdf2Block(
      Hmac hmac, Uint8List salt, int iterations, int blockNumber) {
    // Initial U1 = PRF(Password, Salt || INT_32_BE(blockNumber))
    final saltWithBlock = Uint8List(salt.length + 4);
    saltWithBlock.setRange(0, salt.length, salt);

    // Convert block number to big-endian 32-bit integer
    saltWithBlock[salt.length] = (blockNumber >> 24) & 0xff;
    saltWithBlock[salt.length + 1] = (blockNumber >> 16) & 0xff;
    saltWithBlock[salt.length + 2] = (blockNumber >> 8) & 0xff;
    saltWithBlock[salt.length + 3] = blockNumber & 0xff;

    var u = Uint8List.fromList(hmac.convert(saltWithBlock).bytes);
    final result = Uint8List.fromList(u);

    // Perform iterations
    for (int i = 1; i < iterations; i++) {
      u = Uint8List.fromList(hmac.convert(u).bytes);
      for (int j = 0; j < result.length; j++) {
        result[j] ^= u[j];
      }
    }

    return result;
  }

  /// Check if security is enabled
  static Future<bool> isSecurityEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isSecurityEnabledKey) ?? false;
    } catch (e) {
      logError('SecurityService: Error checking security status: $e');
      return false;
    }
  }

  /// Enable security with master password
  static Future<bool> enableSecurity(String masterPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Generate random salt
      final salt = _generateSalt();

      // Derive encryption key
      final encryptionKey = _deriveKey(masterPassword, salt);

      // Test encryption/decryption with a sample data
      const testData = 'SecurityTest_RandomPlease_2024';
      final encryptedTest = _encryptData(testData, encryptionKey);

      // Store salt and encrypted test data
      await prefs.setString(_saltKey, base64Encode(salt));
      await prefs.setString(_encryptedDataTestKey, base64Encode(encryptedTest));
      await prefs.setBool(_isSecurityEnabledKey, true);

      logInfo('SecurityService: Security enabled successfully');
      return true;
    } catch (e) {
      logError('SecurityService: Error enabling security: $e');
      return false;
    }
  }

  /// Verify master password
  static Future<bool> verifyPassword(String masterPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!await isSecurityEnabled()) {
        return false;
      }

      // Get stored salt and test data
      final saltString = prefs.getString(_saltKey);
      final encryptedTestString = prefs.getString(_encryptedDataTestKey);

      if (saltString == null || encryptedTestString == null) {
        logError('SecurityService: Missing security data');
        return false;
      }

      final salt = base64Decode(saltString);
      final encryptedTest = base64Decode(encryptedTestString);

      // Derive key with provided password
      final encryptionKey = _deriveKey(masterPassword, salt);

      // Try to decrypt test data
      try {
        const expectedData = 'SecurityTest_RandomPlease_2024';
        final decryptedTest = _decryptData(encryptedTest, encryptionKey);

        return decryptedTest == expectedData;
      } catch (e) {
        // Decryption failed, wrong password
        return false;
      }
    } catch (e) {
      logError('SecurityService: Error verifying password: $e');
      return false;
    }
  }

  /// Get encryption key from master password
  static Future<Uint8List?> getEncryptionKey(String masterPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!await isSecurityEnabled()) {
        return null;
      }

      final saltString = prefs.getString(_saltKey);
      if (saltString == null) {
        return null;
      }

      final salt = base64Decode(saltString);
      return _deriveKey(masterPassword, salt);
    } catch (e) {
      logError('SecurityService: Error getting encryption key: $e');
      return null;
    }
  }

  /// Disable security and clear all security data
  static Future<bool> disableSecurity() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_saltKey);
      await prefs.remove(_encryptedDataTestKey);
      await prefs.setBool(_isSecurityEnabledKey, false);

      logInfo('SecurityService: Security disabled successfully');
      return true;
    } catch (e) {
      logError('SecurityService: Error disabling security: $e');
      return false;
    }
  }

  /// Simple XOR encryption (for demonstration - in production use AES)
  static Uint8List _encryptData(String data, Uint8List key) {
    final dataBytes = utf8.encode(data);
    final encrypted = Uint8List(dataBytes.length);

    for (int i = 0; i < dataBytes.length; i++) {
      encrypted[i] = dataBytes[i] ^ key[i % key.length];
    }

    return encrypted;
  }

  /// Simple XOR decryption (for demonstration - in production use AES)
  static String _decryptData(Uint8List encryptedData, Uint8List key) {
    final decrypted = Uint8List(encryptedData.length);

    for (int i = 0; i < encryptedData.length; i++) {
      decrypted[i] = encryptedData[i] ^ key[i % key.length];
    }

    return utf8.decode(decrypted);
  }

  /// Encrypt string data with provided key
  static String encryptString(String data, Uint8List key) {
    final encrypted = _encryptData(data, key);
    return base64Encode(encrypted);
  }

  /// Decrypt string data with provided key
  static String decryptString(String encryptedData, Uint8List key) {
    final encrypted = base64Decode(encryptedData);
    return _decryptData(encrypted, key);
  }

  /// Reset all security settings (for complete reset)
  static Future<void> resetSecurity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_saltKey);
      await prefs.remove(_encryptedDataTestKey);
      await prefs.remove(_isSecurityEnabledKey);
      await prefs.remove(_hasShownSecuritySetupKey);

      logInfo('SecurityService: Security reset completed');
    } catch (e) {
      logError('SecurityService: Error resetting security: $e');
    }
  }

  /// Check if we have shown security setup dialog before
  static Future<bool> hasShownSecuritySetup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hasShownSecuritySetupKey) ?? false;
    } catch (e) {
      logError('SecurityService: Error checking security setup flag: $e');
      return false;
    }
  }

  /// Mark that we have shown security setup dialog
  static Future<void> markSecuritySetupShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasShownSecuritySetupKey, true);
      logInfo('SecurityService: Marked security setup as shown');
    } catch (e) {
      logError('SecurityService: Error marking security setup as shown: $e');
    }
  }
}
