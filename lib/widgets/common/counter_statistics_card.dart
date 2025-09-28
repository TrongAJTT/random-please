import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/counter_statistics_base.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';

/// Reusable widget for displaying counter statistics
class CounterStatisticsCard extends StatelessWidget {
  final CounterStatisticsBase stats;
  final String title;
  final IconData headerIcon;
  final Color headerColor;
  final VoidCallback? onReset;
  final String? resetTooltip;

  const CounterStatisticsCard({
    super.key,
    required this.stats,
    required this.title,
    required this.headerIcon,
    required this.headerColor,
    this.onReset,
    this.resetTooltip,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: headerColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    headerIcon,
                    color: headerColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                if (onReset != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: onReset,
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.red,
                      ),
                      tooltip: resetTooltip ?? 'Reset Counter',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCounterStats(context, loc),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterStats(BuildContext context, AppLocalizations loc) {
    return Column(
      children: [
        // Start time
        _buildStatRow(
          context: context,
          icon: Icons.access_time,
          label: loc.startTime,
          value: stats.formatTime(stats.startTime),
        ),
        const SizedBox(height: 12),

        // Total generations
        _buildStatRow(
          context: context,
          icon: Icons.repeat,
          label: loc.totalGenerations,
          value: stats.totalGenerations.toString(),
        ),
        VerticalSpacingDivider.both(4),

        // Dynamic count rows
        ...stats.counts.entries.map((entry) {
          final key = entry.key;
          final count = entry.value;
          final percentage = stats.percentages[key] ?? 0.0;
          final label = stats.labels[key] ?? key;
          final iconName = stats.icons[key] ?? 'help_outline';

          return Column(
            children: [
              _buildStatRow(
                context: context,
                icon: _getIconFromName(iconName),
                label: label,
                value: '$count (${percentage.toStringAsFixed(1)}%)',
                // Use default color instead of dynamic color
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildStatRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'check_circle':
        return Icons.check_circle;
      case 'cancel':
        return Icons.cancel;
      case 'sports_mma':
        return Icons.sports_mma;
      case 'article':
        return Icons.article;
      case 'content_cut':
        return Icons.content_cut;
      default:
        return Icons.help_outline;
    }
  }
}
