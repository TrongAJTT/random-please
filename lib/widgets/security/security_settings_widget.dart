import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/services/security_manager.dart';
import 'package:random_please/widgets/security/security_dialogs.dart';

class SecuritySettingsWidget extends StatefulWidget {
  final AppLocalizations loc;
  const SecuritySettingsWidget({super.key, required this.loc});

  @override
  State<SecuritySettingsWidget> createState() => _SecuritySettingsWidgetState();
}

class _SecuritySettingsWidgetState extends State<SecuritySettingsWidget> {
  bool _isLoading = false;
  late AppLocalizations loc;

  @override
  void initState() {
    loc = widget.loc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final securityManager = SecurityManager.instance;

    return ListenableBuilder(
      listenable: securityManager,
      builder: (context, child) {
        final isSecurityEnabled = securityManager.isSecurityEnabled;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isSecurityEnabled
                          ? Icons.security
                          : Icons.security_outlined,
                      color: isSecurityEnabled ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        loc.dataProtectionSettings,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isSecurityEnabled
                      ? loc.dataProtectionEnabled
                      : loc.dataProtectionDisabled,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            isSecurityEnabled ? Colors.green : Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSecurityEnabled
                          ? _disableSecurity
                          : _enableSecurity,
                      icon: Icon(
                        isSecurityEnabled
                            ? Icons.security_outlined
                            : Icons.security,
                      ),
                      label: Text(
                        isSecurityEnabled
                            ? loc.disableDataProtection
                            : loc.enableDataProtection,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSecurityEnabled ? Colors.orange : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _enableSecurity() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Show create password dialog
      final password =
          await SecurityDialogs.showCreateMasterPasswordDialog(context, loc);
      if (password == null) {
        return; // User cancelled
      }

      // Enable security
      final success =
          await SecurityManager.instance.enableSecurity(context, password);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.securityEnabled)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.migrationFailed)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.migrationFailed}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _disableSecurity() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Show enter current password dialog
      final password =
          await SecurityDialogs.showEnterMasterPasswordDialog(context, loc);
      if (password == null) {
        return; // User cancelled
      }

      // Disable security
      final success = await SecurityManager.instance.disableSecurity(password);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.securityDisabled)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loc.wrongPassword)),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loc.migrationFailed}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
