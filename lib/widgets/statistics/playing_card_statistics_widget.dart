import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/models/random_generator.dart';

class PlayingCardStatisticsWidget extends ConsumerStatefulWidget {
  final List<PlayingCard> cards;
  final String locale;

  const PlayingCardStatisticsWidget({
    super.key,
    required this.cards,
    required this.locale,
  });

  @override
  ConsumerState<PlayingCardStatisticsWidget> createState() =>
      _PlayingCardStatisticsWidgetState();
}

class _PlayingCardStatisticsWidgetState
    extends ConsumerState<PlayingCardStatisticsWidget> {
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
            .withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
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
                '${widget.cards.length} ${loc.playingCards.toLowerCase()}',
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
        _buildTableRow(loc.leastFrequentRank, stats['leastFrequentRank']),
        _buildTableRow(loc.mostFrequentRank, stats['mostFrequentRank']),
        _buildTableRow(loc.leastFrequentSuit, stats['leastFrequentSuit']),
        _buildTableRow(loc.mostFrequentSuit, stats['mostFrequentSuit']),
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
    if (widget.cards.isEmpty) {
      return {
        'leastFrequentRank': null,
        'mostFrequentRank': null,
        'leastFrequentSuit': null,
        'mostFrequentSuit': null,
      };
    }

    // Count frequencies for ranks and suits
    final Map<String, int> rankCounts = {};
    final Map<String, int> suitCounts = {};

    for (final card in widget.cards) {
      rankCounts[card.rank] = (rankCounts[card.rank] ?? 0) + 1;
      suitCounts[card.suit] = (suitCounts[card.suit] ?? 0) + 1;
    }

    // Find least and most frequent ranks
    String? leastFrequentRank;
    String? mostFrequentRank;
    int minRankCount =
        rankCounts.values.isNotEmpty ? rankCounts.values.first : 0;
    int maxRankCount = 0;

    for (final entry in rankCounts.entries) {
      if (entry.value < minRankCount) {
        minRankCount = entry.value;
        leastFrequentRank = entry.key;
      }
      if (entry.value > maxRankCount) {
        maxRankCount = entry.value;
        mostFrequentRank = entry.key;
      }
    }

    // Check if least frequent is unique
    final leastFrequentCount =
        rankCounts.values.where((count) => count == minRankCount).length;
    if (leastFrequentCount > 1) {
      leastFrequentRank = null;
    }

    // Check if most frequent is unique
    final mostFrequentCount =
        rankCounts.values.where((count) => count == maxRankCount).length;
    if (mostFrequentCount > 1) {
      mostFrequentRank = null;
    }

    // Find least and most frequent suits
    String? leastFrequentSuit;
    String? mostFrequentSuit;
    int minSuitCount =
        suitCounts.values.isNotEmpty ? suitCounts.values.first : 0;
    int maxSuitCount = 0;

    for (final entry in suitCounts.entries) {
      if (entry.value < minSuitCount) {
        minSuitCount = entry.value;
        leastFrequentSuit = entry.key;
      }
      if (entry.value > maxSuitCount) {
        maxSuitCount = entry.value;
        mostFrequentSuit = entry.key;
      }
    }

    // Check if least frequent suit is unique
    final leastFrequentSuitCount =
        suitCounts.values.where((count) => count == minSuitCount).length;
    if (leastFrequentSuitCount > 1) {
      leastFrequentSuit = null;
    }

    // Check if most frequent suit is unique
    final mostFrequentSuitCount =
        suitCounts.values.where((count) => count == maxSuitCount).length;
    if (mostFrequentSuitCount > 1) {
      mostFrequentSuit = null;
    }

    return {
      'leastFrequentRank': leastFrequentRank,
      'mostFrequentRank': mostFrequentRank,
      'leastFrequentSuit': leastFrequentSuit,
      'mostFrequentSuit': mostFrequentSuit,
    };
  }
}
