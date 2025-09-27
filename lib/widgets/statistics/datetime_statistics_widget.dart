import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/datetime_localization_utils.dart';

/// Statistics widget specifically for DateTime data
class DateTimeStatisticsWidget extends ConsumerStatefulWidget {
  final List<DateTime> values;
  final DateTimeStatisticsType type;
  final String locale;

  const DateTimeStatisticsWidget({
    super.key,
    required this.values,
    required this.type,
    this.locale = 'en',
  });

  @override
  ConsumerState<DateTimeStatisticsWidget> createState() =>
      _DateTimeStatisticsWidgetState();
}

class _DateTimeStatisticsWidgetState
    extends ConsumerState<DateTimeStatisticsWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildStatisticsHeader(loc),
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            _buildStatisticsSection(loc, context),
          ],
        ],
      ),
    );
  }

  Widget _buildStatisticsHeader(AppLocalizations loc) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.analytics,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.statistics,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '${widget.values.length} ${loc.items.toLowerCase()}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
          tooltip: _isExpanded ? loc.collapseStatistics : loc.expandStatistics,
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(AppLocalizations loc, BuildContext context) {
    final stats = _calculateStats();

    // Create table-like layout with 2 columns
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      children: [
        _buildTableRow(loc.earliest, stats['earliest']),
        _buildTableRow(loc.latest, stats['latest']),
        _buildTableRow(loc.shortestGap, stats['shortestGap']),
        _buildTableRow(loc.longestGap, stats['longestGap']),
      ],
    );
  }

  TableRow _buildTableRow(String label, String? value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            value ?? '-',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Map<String, String?> _calculateStats() {
    if (widget.values.isEmpty) {
      return {
        'earliest': null,
        'latest': null,
        'shortestGap': null,
        'longestGap': null,
      };
    }

    // Sort values to find earliest and latest
    final sortedValues = List<DateTime>.from(widget.values)..sort();
    final earliest = sortedValues.first;
    final latest = sortedValues.last;

    // Calculate gaps between consecutive elements
    final gaps = <Duration>[];
    for (int i = 0; i < sortedValues.length - 1; i++) {
      gaps.add(sortedValues[i + 1].difference(sortedValues[i]));
    }

    // Find shortest and longest gaps
    Duration? shortestGap;
    Duration? longestGap;

    if (gaps.isNotEmpty) {
      shortestGap = gaps.reduce((a, b) => a < b ? a : b);
      longestGap = gaps.reduce((a, b) => a > b ? a : b);
    }

    // Format results based on type
    String formatDateTime(DateTime dateTime) {
      switch (widget.type) {
        case DateTimeStatisticsType.dateTime:
          return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
        case DateTimeStatisticsType.date:
          return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
        case DateTimeStatisticsType.time:
          return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
    }

    String? formatDuration(Duration? duration) {
      if (duration == null) return null;

      switch (widget.type) {
        case DateTimeStatisticsType.dateTime:
          return DateTimeLocalizationUtils.formatDateTimeDuration(
              duration, widget.locale);
        case DateTimeStatisticsType.date:
          return DateTimeLocalizationUtils.formatDateDuration(
              duration, widget.locale);
        case DateTimeStatisticsType.time:
          return DateTimeLocalizationUtils.formatTimeDuration(
              duration, widget.locale);
      }
    }

    return {
      'earliest': formatDateTime(earliest),
      'latest': formatDateTime(latest),
      'shortestGap': formatDuration(shortestGap),
      'longestGap': formatDuration(longestGap),
    };
  }
}

/// Enum for different types of DateTime statistics
enum DateTimeStatisticsType {
  dateTime,
  date,
  time,
}
