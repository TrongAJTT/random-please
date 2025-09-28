import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/api/api_manager.dart';

class LocalApiSettingsWidget extends ConsumerWidget {
  const LocalApiSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiState = ref.watch(apiServerStateProvider);
    final apiNotifier = ref.read(apiServerStateProvider.notifier);

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
                const Icon(Icons.api, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Local API Server',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Platform support check
            if (!apiState.isSupported) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Local API không được hỗ trợ trên nền tảng web.\nChỉ hoạt động trên Windows và Android.',
                        style: TextStyle(color: Colors.orange[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Status indicator
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: apiState.isRunning
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: apiState.isRunning
                        ? Colors.green.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      apiState.isRunning
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: apiState.isRunning ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            apiState.isRunning
                                ? 'Server đang chạy'
                                : 'Server đã dừng',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: apiState.isRunning
                                  ? Colors.green[800]
                                  : Colors.grey[800],
                            ),
                          ),
                          if (apiState.isRunning &&
                              apiState.baseUrl.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              apiState.baseUrl,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Control buttons
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: apiState.isRunning
                        ? null
                        : () => _startServer(context, apiNotifier),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Khởi động Server'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: !apiState.isRunning
                        ? null
                        : () => _stopServer(context, apiNotifier),
                    icon: const Icon(Icons.stop),
                    label: const Text('Dừng Server'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
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
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Lỗi: ${apiState.error}',
                          style: TextStyle(color: Colors.red[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // API Info
              if (apiState.isRunning) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'API Endpoints',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                _buildEndpointsList(apiState.baseUrl),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEndpointsList(String baseUrl) {
    final endpoints = [
      {'path': '/health', 'description': 'Health check'},
      {'path': '/info', 'description': 'API information'},
      {'path': '/generators', 'description': 'List available generators'},
      {
        'path': '/api/v1/random/number',
        'description': 'Generate random numbers'
      },
      {'path': '/api/v1/random/color', 'description': 'Generate random colors'},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: endpoints.map((endpoint) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    endpoint['path']!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    endpoint['description']!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  onPressed: () =>
                      _copyToClipboard('$baseUrl${endpoint['path']}'),
                  tooltip: 'Copy URL',
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _startServer(
      BuildContext context, ApiServerStateNotifier notifier) async {
    try {
      await notifier.startServer();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ API Server đã khởi động thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Không thể khởi động server: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopServer(
      BuildContext context, ApiServerStateNotifier notifier) async {
    try {
      await notifier.stopServer();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🛑 API Server đã dừng'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Lỗi khi dừng server: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _copyToClipboard(String text) {
    // TODO: Implement clipboard copy
    print('Copy to clipboard: $text');
  }
}
