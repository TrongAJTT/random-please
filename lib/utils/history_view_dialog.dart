import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/generation_history_service.dart';
import '../l10n/app_localizations.dart';

class HistoryViewDialog {
  static Future<void> show({
    required BuildContext context,
    required GenerationHistoryItem item,
    String? customTitle,
  }) async {
    final loc = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(
                customTitle ?? loc.generationHistory,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: loc.copyToClipboard,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: item.value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.copied)),
                );
              },
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timestamp
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${loc.generatedAt}: ${_formatDateTime(item.timestamp)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

              const SizedBox(height: 16),

              // Content label
              Text(
                loc.results,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 8),

              // Scrollable content
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withOpacity(0.3),
                  ),
                  child: SingleChildScrollView(
                    child: _buildContentWidget(context, item),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).closeButtonLabel),
          ),
          FilledButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: item.value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.copied)),
              );
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.copy),
            label: Text(loc.copyToClipboard),
          ),
        ],
      ),
    );
  }

  static Widget _buildContentWidget(
      BuildContext context, GenerationHistoryItem item) {
    final content = item.value;

    // Check if content looks like team results (contains "Team 1:", "Team 2:", etc.)
    if (content.contains(RegExp(r'Team \d+:'))) {
      return _buildTeamResults(context, content);
    }

    // Check if content is a list (contains commas or newlines)
    if (content.contains(',') || content.contains('\n')) {
      return _buildListResults(context, content);
    }

    // Default: show as plain text
    return SelectableText(
      content,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  static Widget _buildTeamResults(BuildContext context, String content) {
    final teams =
        content.split('\n').where((line) => line.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: teams.asMap().entries.map((entry) {
        final index = entry.key;
        final team = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SelectableText(
                  team,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  static Widget _buildListResults(BuildContext context, String content) {
    List<String> items;

    // Split by newlines first, then by commas if no newlines
    if (content.contains('\n')) {
      items =
          content.split('\n').where((item) => item.trim().isNotEmpty).toList();
    } else {
      items = content
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SelectableText(
                  item,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
