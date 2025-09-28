import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/api_state_provider.dart';
import '../l10n/app_localizations.dart';

class ApiManagementWidget extends ConsumerStatefulWidget {
  const ApiManagementWidget({super.key});

  @override
  ConsumerState<ApiManagementWidget> createState() =>
      _ApiManagementWidgetState();
}

class _ApiManagementWidgetState extends ConsumerState<ApiManagementWidget> {
  final _portController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize port with current state
    final apiState = ref.read(apiStateProvider);
    _portController.text = apiState.port.toString();
  }

  @override
  void dispose() {
    _portController.dispose();
    super.dispose();
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.apiServerStopped),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        final port = int.tryParse(_portController.text);
        if (port == null || port < 1024 || port > 65535) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.invalidPortRange),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        await apiNotifier.startServer(port: port);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.apiServerStarted),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
    final apiNotifier = ref.read(apiStateProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    if (!apiNotifier.isSupported) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.localApiNotSupported,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.localApiNotSupportedDescription,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.api,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.localApiManagement,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: apiState.isRunning
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: apiState.isRunning ? Colors.green : Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    apiState.isRunning
                        ? Icons.check_circle
                        : Icons.radio_button_off,
                    color: apiState.isRunning ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          apiState.isRunning
                              ? l10n.apiServerRunning
                              : l10n.apiServerStopped,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: apiState.isRunning
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                        ),
                        if (apiState.isRunning &&
                            apiState.baseUrl.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            apiState.baseUrl,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Port configuration
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _portController,
                    enabled: !apiState.isRunning && !_isLoading,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.apiPort,
                      hintText: '4000',
                      helperText: l10n.portRangeHelper,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final port = int.tryParse(value);
                      if (port != null && !apiState.isRunning) {
                        apiNotifier.updatePort(port);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _toggleServer,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            apiState.isRunning ? Icons.stop : Icons.play_arrow),
                    label:
                        Text(apiState.isRunning ? l10n.apiStop : l10n.apiStart),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: apiState.isRunning
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            // Error display
            if (apiState.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
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

            const SizedBox(height: 16),

            // Quick links when running
            if (apiState.isRunning) ...[
              const Divider(),
              const SizedBox(height: 8),
              Text(
                l10n.quickLinks,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildQuickLinkChip(
                    context,
                    '${apiState.baseUrl}/info',
                    l10n.apiDocumentation,
                    Icons.description,
                  ),
                  _buildQuickLinkChip(
                    context,
                    '${apiState.baseUrl}/number',
                    l10n.apiNumberGenerator,
                    Icons.numbers,
                  ),
                  _buildQuickLinkChip(
                    context,
                    '${apiState.baseUrl}/color',
                    l10n.apiColorGenerator,
                    Icons.palette,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinkChip(
      BuildContext context, String url, String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      onPressed: () {
        // TODO: Mở URL trong browser hoặc hiển thị trong dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label: $url'),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.apiCopy,
              onPressed: () {
                // TODO: Copy to clipboard
              },
            ),
          ),
        );
      },
    );
  }
}
