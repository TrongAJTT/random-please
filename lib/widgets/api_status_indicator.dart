import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/api_state_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/url_utils.dart';

class ApiStatusIndicator extends ConsumerWidget {
  const ApiStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiState = ref.watch(apiStateProvider);
    final apiNotifier = ref.read(apiStateProvider.notifier);

    // Don't show indicator if API is not supported or not running
    if (!apiNotifier.isSupported || !apiState.isRunning) {
      return const SizedBox.shrink();
    }

    return Tooltip(
      message: apiState.isRunning
          ? 'API Server: ${apiState.baseUrl} (Click to open)'
          : AppLocalizations.of(context)!.apiServerStopped,
      child: InkWell(
        onTap: apiState.isRunning
            ? () async {
                try {
                  await UriUtils.viewUniUrl(
                    context: context,
                    url: apiState.baseUrl,
                  );
                } catch (e) {
                  // Fallback: show URL in snackbar if opening fails
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('API URL: ${apiState.baseUrl}'),
                        action: SnackBarAction(
                          label: 'Copy',
                          onPressed: () {
                            // Copy URL to clipboard
                          },
                        ),
                      ),
                    );
                  }
                }
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: apiState.isRunning
                ? Colors.green.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: apiState.isRunning ? Colors.green : Colors.grey,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                apiState.isRunning ? Icons.api : Icons.api_outlined,
                size: 16,
                color: apiState.isRunning ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                apiState.isRunning ? 'API' : 'API',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: apiState.isRunning ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
