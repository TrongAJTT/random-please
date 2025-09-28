import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import '../providers/api_state_provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_localizations.dart';

/// Simplified API Management Widget - only shows start/stop functionality
/// Port configuration is moved to settings
class ApiManagementWidget extends ConsumerStatefulWidget {
  const ApiManagementWidget({super.key});

  @override
  ConsumerState<ApiManagementWidget> createState() =>
      _ApiManagementWidgetState();
}

class _ApiManagementWidgetState extends ConsumerState<ApiManagementWidget> {
  bool _isLoading = false;
  late AppLocalizations loc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loc = AppLocalizations.of(context)!;
  }

  Future<void> _toggleServer() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final apiNotifier = ref.read(apiStateProvider.notifier);
      final apiState = ref.read(apiStateProvider);

      if (apiState.isRunning) {
        await apiNotifier.stopServer();
        if (mounted) {
          SnackBarUtils.showTyped(
              context, loc.apiServerStopped, SnackBarType.success);
        }
      } else {
        // Get port from settings instead of text field
        final settings = ref.read(settingsProvider);
        final port = settings.localApiPort;

        await apiNotifier.startServer(port: port);
        if (mounted) {
          SnackBarUtils.showTyped(
              context, loc.apiServerStarted, SnackBarType.success);
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(context, 'Error: $e', SnackBarType.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiState = ref.watch(apiStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.api,
                  color: apiState.isRunning ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.localApiServer,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        apiState.isRunning
                            ? '${l10n.running} - ${apiState.baseUrl}'
                            : l10n.stopped,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: apiState.isRunning
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Port info (read-only, configured in settings)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.settings, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${l10n.apiPort}: ${ref.watch(settingsProvider).localApiPort}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Text(
                    l10n.configureInSettings,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Start/Stop button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _toggleServer,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(apiState.isRunning ? Icons.stop : Icons.play_arrow),
                label: Text(
                  apiState.isRunning ? l10n.stopServer : l10n.startServer,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: apiState.isRunning
                      ? Colors.red.shade600
                      : Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            // Error display
            if (apiState.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        apiState.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
