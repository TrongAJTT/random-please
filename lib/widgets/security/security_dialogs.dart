import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/services/security_service.dart';
import 'package:random_please/services/data_migration_service.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/widgets/generic/hold_button.dart';

class SecurityDialogs {
  /// Show initial security setup dialog (Dialog A)
  static Future<bool?> showSecuritySetupDialog(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(loc.securitySetupTitle),
        content: Text(loc.securitySetupMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.skipSecurity),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.setMasterPassword),
          ),
        ],
      ),
    );
  }

  /// Show create master password dialog (Dialog B)
  static Future<String?> showCreateMasterPasswordDialog(
      BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool obscurePassword = true;
    bool obscureConfirm = true;

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(loc.createMasterPasswordTitle),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 400,
              maxWidth: 600,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.createMasterPasswordMessage),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: loc.enterPassword,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return loc.passwordTooShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    decoration: InputDecoration(
                      labelText: loc.confirmPassword,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirm
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirm = !obscureConfirm;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != passwordController.text) {
                        return loc.passwordMismatch;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop(passwordController.text);
                }
              },
              child: Text(loc.confirm),
            ),
          ],
        ),
      ),
    );
  }

  /// Show enter master password dialog (Dialog C)
  static Future<String?> showEnterMasterPasswordDialog(BuildContext context,
      {bool showForgotButton = false}) async {
    final loc = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();
    bool obscurePassword = true;

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(loc.enterMasterPasswordTitle),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 400,
              maxWidth: 600,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(loc.enterMasterPasswordMessage),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  autofocus: true,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: loc.enterPassword,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      Navigator.of(context).pop(value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(loc.cancel),
              ),
            ),
            if (showForgotButton)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop('__FORGOT_PASSWORD__'),
                  child: Text(loc.forgotPasswordButton),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                autofocus: true,
                onPressed: () {
                  if (passwordController.text.isNotEmpty) {
                    Navigator.of(context).pop(passwordController.text);
                  }
                },
                child: Text(loc.confirm),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show data loss confirmation dialog (Dialog D)
  static Future<bool?> showDataLossConfirmationDialog(
      BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(loc.confirmDataLossTitle),
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 400,
            maxWidth: 600,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(loc.confirmDataLossMessage),
              const SizedBox(height: 20),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.cancel),
          ),
          HoldButton(
            text: loc.holdToConfirm,
            holdDuration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            progressColor: Colors.red.withValues(alpha: .5),
            onHoldComplete: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }

  /// Show migration loading dialog
  static Future<void> showMigrationLoadingDialog(
      BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Handle complete security setup flow
  static Future<bool> handleSecuritySetup(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    try {
      // Mark that we have shown the setup dialog
      await SecurityService.markSecuritySetupShown();

      // Show initial setup dialog
      final wantsSecurity = await showSecuritySetupDialog(context);
      if (wantsSecurity != true) {
        return false; // User chose to skip security
      }

      // Show create password dialog
      final password = await showCreateMasterPasswordDialog(context);
      if (password == null) {
        return false; // User cancelled
      }

      // Show migration loading dialog
      if (context.mounted) {
        showMigrationLoadingDialog(context, loc.migrationInProgress);
      }

      // Enable security
      final securityEnabled = await SecurityService.enableSecurity(password);
      if (!securityEnabled) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          SnackBarUtils.showTyped(
              context, loc.migrationFailed, SnackBarType.error);
        }
        return false;
      }

      // Migrate data to encrypted format
      final migrationSuccess =
          await DataMigrationService.migrateToEncrypted(password);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (!migrationSuccess) {
        if (context.mounted) {
          SnackBarUtils.showTyped(
              context, loc.migrationFailed, SnackBarType.error);
        }
        // Rollback security
        await SecurityService.disableSecurity();
        return false;
      }

      if (context.mounted) {
        SnackBarUtils.showTyped(
            context, loc.securityEnabled, SnackBarType.success);
      }

      return true;
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.of(context).pop();
        SnackBarUtils.showTyped(
            context, loc.migrationFailed, SnackBarType.error);
      }
      return false;
    }
  }

  /// Handle security login flow
  static Future<String?> handleSecurityLogin(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    bool showForgotButton = false;

    while (true) {
      final password = await showEnterMasterPasswordDialog(context,
          showForgotButton: showForgotButton);

      if (password == null) {
        // User cancelled - this should not be allowed for security-enabled app
        continue;
      }

      if (password == '__FORGOT_PASSWORD__') {
        // User wants to reset data
        final confirmed = await showDataLossConfirmationDialog(context);
        if (confirmed == true) {
          // Clear all data and disable security
          await DataMigrationService.clearEncryptedData();
          await SecurityService.resetSecurity();
          if (context.mounted) {
            SnackBarUtils.showTyped(
                context,
                'Data cleared. You can now use the app without password.',
                SnackBarType.info);
          }
          return null; // No password needed anymore
        }
        continue;
      }

      // Verify password
      final isValid = await SecurityService.verifyPassword(password);
      if (isValid) {
        return password; // Success
      } else {
        // Wrong password
        if (context.mounted) {
          SnackBarUtils.showTyped(
              context, loc.wrongPassword, SnackBarType.error);
        }
        showForgotButton = true; // Show forgot button after first wrong attempt
      }
    }
  }
}
