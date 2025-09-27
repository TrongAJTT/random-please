import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/number_formatter.dart';
import 'package:random_please/utils/variables_utils.dart';

class StatisticsWidget extends StatefulWidget {
  final List<int> values;
  final bool isInteger;
  final int decimalPlaces;

  const StatisticsWidget({
    Key? key,
    required this.values,
    this.isInteger = true,
    this.decimalPlaces = 0,
  }) : super(key: key);

  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  bool _isExpanded = true;
  static const tabletThreshold = 100000;

  Map<String, dynamic> _calculateStats() {
    if (widget.values.isEmpty) {
      return {
        'min': 0.0,
        'max': 0.0,
        'avg': 0.0,
        'total': 0.0,
        'leastFrequent': null,
        'mostFrequent': null,
        'minGap': null,
        'maxGap': null
      };
    }

    final numbers = widget.values.map((v) => v.toDouble()).toList();
    final min = numbers.reduce((a, b) => a < b ? a : b);
    final max = numbers.reduce((a, b) => a > b ? a : b);
    final total = numbers.reduce((a, b) => a + b);
    final avg = total / numbers.length;

    // Calculate frequency statistics
    final frequencyMap = <int, int>{};
    for (final value in widget.values) {
      frequencyMap[value] = (frequencyMap[value] ?? 0) + 1;
    }

    final frequencies = frequencyMap.values.toList();
    final minFreq = frequencies.reduce((a, b) => a < b ? a : b);
    final maxFreq = frequencies.reduce((a, b) => a > b ? a : b);

    // Find least and most frequent values
    int? leastFrequent, mostFrequent;
    if (minFreq == maxFreq) {
      // All values have same frequency
      leastFrequent = null;
      mostFrequent = null;
    } else {
      // Check if there's only one value with min frequency
      final minFreqValues =
          frequencyMap.entries.where((e) => e.value == minFreq).toList();
      if (minFreqValues.length == 1) {
        leastFrequent = minFreqValues.first.key;
      } else {
        leastFrequent = null; // Multiple values have same min frequency
      }

      // Check if there's only one value with max frequency
      final maxFreqValues =
          frequencyMap.entries.where((e) => e.value == maxFreq).toList();
      if (maxFreqValues.length == 1) {
        mostFrequent = maxFreqValues.first.key;
      } else {
        mostFrequent = null; // Multiple values have same max frequency
      }
    }

    // Calculate gap statistics
    final sortedValues = List<int>.from(widget.values)..sort();
    double? minGap, maxGap;
    if (sortedValues.length > 1) {
      final gaps = <double>[];
      for (int i = 1; i < sortedValues.length; i++) {
        gaps.add((sortedValues[i] - sortedValues[i - 1]).toDouble());
      }
      minGap = gaps.reduce((a, b) => a < b ? a : b);
      maxGap = gaps.reduce((a, b) => a > b ? a : b);
    }

    return {
      'min': min,
      'max': max,
      'avg': avg,
      'total': total,
      'leastFrequent': leastFrequent?.toDouble(),
      'mostFrequent': mostFrequent?.toDouble(),
      'minGap': minGap,
      'maxGap': maxGap
    };
  }

  Widget _buildStatItem(
      String label, dynamic value, AppLocalizations loc, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value == null ? '—' : _formatValue(value, context),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }

  String _formatValue(dynamic value, BuildContext context) {
    final locale = NumberFormatter.getCurrentLocale(context);
    return NumberFormatter.formatNumber(
      value.toDouble(),
      locale,
      isInteger: widget.isInteger,
      decimalPlaces: widget.isInteger ? 0 : widget.decimalPlaces,
    );
  }

  Widget _buildStatisticsSection(AppLocalizations loc, BuildContext context) {
    final stats = _calculateStats();
    final isMobile = isMobileContext(context);
    final shouldSplitRows = isMobile &&
        widget.values.isNotEmpty &&
        widget.values.reduce((a, b) => a > b ? a : b) >= tabletThreshold;

    Widget buildDivider() => Container(
        width: 1,
        height: 24,
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2));

    if (shouldSplitRows) {
      // Mobile layout: 4 rows with 2 items each
      return Column(
        children: [
          // Row 1: Min, Max
          Row(
            children: [
              Expanded(
                  child:
                      _buildStatItem(loc.minimum, stats['min']!, loc, context)),
              buildDivider(),
              Expanded(
                  child:
                      _buildStatItem(loc.maximum, stats['max']!, loc, context)),
            ],
          ),
          const SizedBox(height: 12),
          // Row 2: Avg, Total
          Row(
            children: [
              Expanded(
                  child:
                      _buildStatItem(loc.average, stats['avg']!, loc, context)),
              buildDivider(),
              Expanded(
                  child:
                      _buildStatItem(loc.total, stats['total']!, loc, context)),
            ],
          ),
          const SizedBox(height: 12),
          // Row 3: Least, Most
          Row(
            children: [
              Expanded(
                  child: _buildStatItem(
                      loc.leastFrequent, stats['leastFrequent'], loc, context)),
              buildDivider(),
              Expanded(
                  child: _buildStatItem(
                      loc.mostFrequent, stats['mostFrequent'], loc, context)),
            ],
          ),
          const SizedBox(height: 12),
          // Row 4: Min Gap, Max Gap
          Row(
            children: [
              Expanded(
                  child: _buildStatItem(
                      loc.minGap, stats['minGap'], loc, context)),
              buildDivider(),
              Expanded(
                  child: _buildStatItem(
                      loc.maxGap, stats['maxGap'], loc, context)),
            ],
          ),
        ],
      );
    } else {
      // Desktop layout: 2 rows with 4 items each
      return Column(
        children: [
          // Row 1: Min, Max, Avg, Total
          Row(
            children: [
              Expanded(
                  child:
                      _buildStatItem(loc.minimum, stats['min']!, loc, context)),
              buildDivider(),
              Expanded(
                  child:
                      _buildStatItem(loc.maximum, stats['max']!, loc, context)),
              buildDivider(),
              Expanded(
                  child:
                      _buildStatItem(loc.average, stats['avg']!, loc, context)),
              buildDivider(),
              Expanded(
                  child:
                      _buildStatItem(loc.total, stats['total']!, loc, context)),
            ],
          ),
          const SizedBox(height: 12),
          // Row 2: Least, Most, Min Gap, Max Gap
          Row(
            children: [
              Expanded(
                  child: _buildStatItem(
                      loc.leastFrequent, stats['leastFrequent'], loc, context)),
              buildDivider(),
              Expanded(
                  child: _buildStatItem(
                      loc.mostFrequent, stats['mostFrequent'], loc, context)),
              buildDivider(),
              Expanded(
                  child: _buildStatItem(
                      loc.minGap, stats['minGap'], loc, context)),
              buildDivider(),
              Expanded(
                  child: _buildStatItem(
                      loc.maxGap, stats['maxGap'], loc, context)),
            ],
          ),
        ],
      );
    }
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
}
