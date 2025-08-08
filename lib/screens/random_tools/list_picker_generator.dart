import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/utils/generic_dialog_utils.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';

class ListPickerGeneratorScreen extends StatefulWidget {
  final bool isEmbedded;

  const ListPickerGeneratorScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<ListPickerGeneratorScreen> createState() =>
      _ListPickerGeneratorScreenState();
}

class _ListPickerGeneratorScreenState extends State<ListPickerGeneratorScreen> {
  static const String boxName = 'listPickerGeneratorBox';
  late Box<ListPickerGeneratorState> _box;
  late ListPickerGeneratorState _state;
  bool _isBoxOpen = false;
  bool _historyEnabled = false;
  List<GenerationHistoryItem> _historyItems = [];

  final TextEditingController _itemController = TextEditingController();
  List<String> _results = [];

  static const String _historyType = 'listpicker';
  @override
  void initState() {
    super.initState();
    _initHive();
    _loadHistory();
  }

  Future<void> _initHive() async {
    _box = await Hive.openBox<ListPickerGeneratorState>(boxName);
    _state = _box.get('state') ?? ListPickerGeneratorState.createDefault();
    setState(() {
      _isBoxOpen = true;
    });
  }

  Future<void> _loadHistory() async {
    final enabled = await GenerationHistoryService.isHistoryEnabled();
    final history = await GenerationHistoryService.getHistory(_historyType);
    setState(() {
      _historyEnabled = enabled;
      _historyItems = history;
    });
  }

  Future<void> _showCreateListDialog(AppLocalizations loc) async {
    final TextEditingController nameController = TextEditingController();
    String? errorMessage;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(loc.createListDialog),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: loc.enterListName,
                    errorText: errorMessage,
                    counterText: '${nameController.text.length}/30',
                  ),
                  maxLength: 30,
                  onChanged: (value) {
                    setDialogState(() {
                      if (value.isEmpty) {
                        errorMessage = loc.listNameRequired;
                      } else if (value.length > 30) {
                        errorMessage = loc.listNameTooLong;
                      } else if (_state.savedLists
                          .any((list) => list.name == value)) {
                        errorMessage = loc.listNameExists;
                      } else {
                        errorMessage = null;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: errorMessage == null && nameController.text.isNotEmpty
                  ? () => Navigator.of(context).pop(nameController.text.trim())
                  : null,
              child: Text(loc.create),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      final newList = CustomList(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: result,
        items: [],
        createdAt: DateTime.now(),
      );

      setState(() {
        _state.savedLists.add(newList);
        _state.currentList = newList;
        _state.lastUpdated = DateTime.now();
      });
      _saveState();
    }
  }

  void _saveState() {
    if (_isBoxOpen) {
      _box.put('state', _state);
    }
  }

  void _addItemToCurrentList() {
    final text = _itemController.text.trim();
    if (text.isNotEmpty && _state.currentList != null) {
      setState(() {
        _state.currentList!.items.add(ListItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          value: text,
          createdAt: DateTime.now(),
        ));
        _state.lastUpdated = DateTime.now();
        _itemController.clear();
      });
      _saveState();
    }
  }

  void _removeItem(String itemId) {
    if (_state.currentList != null) {
      setState(() {
        _state.currentList!.items.removeWhere((item) => item.id == itemId);
        _state.lastUpdated = DateTime.now();
      });
      _saveState();
    }
  }

  void _switchToList(CustomList list) {
    setState(() {
      _state.currentList = list;
      _state.lastUpdated = DateTime.now();
    });
    _saveState();
  }

  void _deleteList(CustomList list) async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await GenericDialogUtils.showSimpleGenericClearDialog(
      context: context,
      title: loc.deleteList,
      description:
          'Are you sure you want to delete "${list.name}"? This action cannot be undone.',
      onConfirm: () {},
    );

    if (confirmed == true) {
      setState(() {
        _state.savedLists.removeWhere((l) => l.id == list.id);
        if (_state.currentList?.id == list.id) {
          _state.currentList =
              _state.savedLists.isNotEmpty ? _state.savedLists.first : null;
        }
        _state.lastUpdated = DateTime.now();
      });
      _saveState();
    }
  }

  void _pickRandomItems() async {
    if (_state.currentList == null || _state.currentList!.items.isEmpty) return;

    final items = List<ListItem>.from(_state.currentList!.items);
    List<String> results = [];

    switch (_state.mode) {
      case ListPickerMode.random:
        // Pick random items (no duplicates)
        items.shuffle();
        final count =
            _state.quantity.clamp(1, (items.length - 1).clamp(1, items.length));
        results = items.take(count).map((item) => item.value).toList();
        break;

      case ListPickerMode.shuffle:
        // Shuffle all items and take specified amount
        items.shuffle();
        final count = _state.quantity.clamp(2, items.length);
        results = items.take(count).map((item) => item.value).toList();
        break;

      case ListPickerMode.team:
        // Divide items into teams
        items.shuffle();
        final numberOfTeams = _state.quantity
            .clamp(2, (items.length / 2).ceil().clamp(2, items.length));
        final itemsPerTeam = (items.length / numberOfTeams).ceil();

        results = [];
        for (int i = 0; i < numberOfTeams; i++) {
          final startIndex = i * itemsPerTeam;
          final endIndex = ((i + 1) * itemsPerTeam).clamp(0, items.length);
          if (startIndex < items.length) {
            final teamItems = items.sublist(startIndex, endIndex);
            final teamNames = teamItems.map((item) => item.value).join(', ');
            results.add(
                '${AppLocalizations.of(context)!.modeTeam} ${i + 1}: $teamNames');
          }
        }
        break;
    }

    _results = results;
    setState(() {});

    // Save to history if enabled
    if (_historyEnabled && _results.isNotEmpty) {
      // Save each result separately to history for better display
      await GenerationHistoryService.addHistoryItem(
        _results.join('; '),
        _historyType,
      );
      await _loadHistory(); // Refresh history
    }
  }

  Widget _buildListSelector() {
    final loc = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _state.isListSelectorCollapsed =
                            !_state.isListSelectorCollapsed;
                        _state.lastUpdated = DateTime.now();
                      });
                      _saveState();
                    },
                    child: Row(
                      children: [
                        Text(
                          loc.selectList,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        if (_state.currentList != null &&
                            _state.isListSelectorCollapsed)
                          Text(
                            '(${_state.currentList!.name} - ${_state.currentList!.items.length} ${loc.items.toLowerCase()})',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _state.isListSelectorCollapsed =
                          !_state.isListSelectorCollapsed;
                      _state.lastUpdated = DateTime.now();
                    });
                    _saveState();
                  },
                  icon: Icon(_state.isListSelectorCollapsed
                      ? Icons.expand_more
                      : Icons.expand_less),
                  tooltip: _state.isListSelectorCollapsed
                      ? loc.expand
                      : loc.collapse,
                ),
                if (!_state.isListSelectorCollapsed)
                  IconButton(
                    onPressed: () => _showCreateListDialog(loc),
                    icon: const Icon(Icons.add),
                    tooltip: loc.createNewList,
                  ),
              ],
            ),
            if (!_state.isListSelectorCollapsed) ...[
              const SizedBox(height: 8),
              if (_state.savedLists.isEmpty)
                Text(
                  AppLocalizations.of(context)!.noListsAvailable,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                )
              else
                Wrap(
                  spacing: 8,
                  children: _state.savedLists.map((list) {
                    final isSelected = _state.currentList?.id == list.id;
                    return FilterChip(
                      label: Text('${list.name} (${list.items.length})'),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) _switchToList(list);
                      },
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _deleteList(list),
                    );
                  }).toList(),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListManager() {
    if (_state.currentList == null) {
      return SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.selectOrCreateList,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
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
            Text(
              '${AppLocalizations.of(context)!.manageList}: ${_state.currentList!.name}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.addItem,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addItemToCurrentList(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addItemToCurrentList,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_state.currentList!.items.isNotEmpty) ...[
              Text(
                '${AppLocalizations.of(context)!.items} (${_state.currentList!.items.length}):',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth > 500;

                  if (isWideScreen) {
                    // Two column layout for wide screens
                    final items = _state.currentList!.items;
                    final halfLength = (items.length / 2).ceil();
                    final leftItems = items.take(halfLength).toList();
                    final rightItems = items.skip(halfLength).toList();

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: leftItems
                                .map((item) => Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline
                                              .withValues(alpha: 0.2),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        dense: true,
                                        title: Text(item.value),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 20),
                                          onPressed: () => _removeItem(item.id),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: rightItems
                                .map((item) => Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline
                                              .withValues(alpha: 0.2),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        dense: true,
                                        title: Text(item.value),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 20),
                                          onPressed: () => _removeItem(item.id),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Single column layout for narrow screens
                    return Column(
                      children: _state.currentList!.items
                          .map((item) => Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withValues(alpha: 0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: Text(item.value),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    onPressed: () => _removeItem(item.id),
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratorOptions() {
    final loc = AppLocalizations.of(context)!;
    final maxItems = _state.currentList?.items.length ?? 0;

    // Handle edge case when no items
    if (maxItems == 0) {
      return SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.generatorOptions,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  loc.selectOrCreateList,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Calculate min/max based on mode
    int minQuantity = 1;
    int maxQuantity = maxItems;

    switch (_state.mode) {
      case ListPickerMode.random:
        minQuantity = 1;
        maxQuantity = maxItems >= 2 ? (maxItems - 1) : maxItems;
        break;
      case ListPickerMode.shuffle:
        minQuantity = maxItems >= 2 ? 2 : 1;
        maxQuantity = maxItems;
        break;
      case ListPickerMode.team:
        minQuantity = maxItems >= 3 ? 2 : 1;
        maxQuantity = maxItems >= 3 ? (maxItems / 2).ceil() : 1;
        break;
    }

    // Ensure minQuantity <= maxQuantity
    if (minQuantity > maxQuantity) {
      minQuantity = maxQuantity;
    }

    final safeQuantity = _state.quantity.clamp(minQuantity, maxQuantity);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.generatorOptions,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 16),

            // Mode Selector
            Text(
              loc.listPickerMode,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<ListPickerMode>(
                segments: [
                  ButtonSegment<ListPickerMode>(
                    value: ListPickerMode.random,
                    label: Text(loc.modeRandom),
                    tooltip: loc.modeRandomDesc,
                    enabled: maxItems >= 2,
                  ),
                  ButtonSegment<ListPickerMode>(
                    value: ListPickerMode.shuffle,
                    label: Text(loc.modeShuffle),
                    tooltip: loc.modeShuffleDesc,
                    enabled: maxItems >= 2,
                  ),
                  ButtonSegment<ListPickerMode>(
                    value: ListPickerMode.team,
                    label: Text(loc.modeTeam),
                    tooltip: loc.modeTeamDesc,
                    enabled: maxItems >= 3,
                  ),
                ],
                selected: {_state.mode},
                onSelectionChanged: (Set<ListPickerMode> selection) {
                  setState(() {
                    _state.mode = selection.first;
                    // Adjust quantity to fit new mode constraints
                    switch (_state.mode) {
                      case ListPickerMode.random:
                        _state.quantity = _state.quantity
                            .clamp(1, (maxItems - 1).clamp(1, maxItems));
                        break;
                      case ListPickerMode.shuffle:
                        _state.quantity = _state.quantity.clamp(2, maxItems);
                        break;
                      case ListPickerMode.team:
                        _state.quantity = _state.quantity
                            .clamp(2, (maxItems / 2).ceil().clamp(2, maxItems));
                        break;
                    }
                    _state.lastUpdated = DateTime.now();
                  });
                  _saveState();
                },
              ),
            ),

            const SizedBox(height: 8),

            // Quantity Slider
            if (maxItems > 0)
              OptionSlider<int>(
                label: _state.mode == ListPickerMode.team
                    ? loc.teams
                    : loc.quantity,
                currentValue: safeQuantity,
                options: List.generate(
                  maxQuantity - minQuantity + 1,
                  (index) => SliderOption(
                    value: minQuantity + index,
                    label: '${minQuantity + index}',
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _state.quantity = value;
                    _state.lastUpdated = DateTime.now();
                  });
                  _saveState();
                },
                layout: OptionSliderLayout.none,
              )
            else
              SizedBox(
                width: double.infinity,
                child: Text(
                  loc.selectOrCreateList,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),

            VerticalSpacingDivider.onlyBottom(8),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                onPressed: _state.currentList != null &&
                        _state.currentList!.items.isNotEmpty
                    ? _pickRandomItems
                    : null,
                icon: Icon(
                  _state.mode == ListPickerMode.random
                      ? Icons.shuffle
                      : _state.mode == ListPickerMode.shuffle
                          ? Icons.shuffle_outlined
                          : Icons.group,
                ),
                label: Text(_getGenerateButtonText(loc)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGenerateButtonText(AppLocalizations loc) {
    switch (_state.mode) {
      case ListPickerMode.random:
        return loc.generateRandom;
      case ListPickerMode.shuffle:
        return loc.modeShuffle;
      case ListPickerMode.team:
        return '${loc.modeTeam} (${_state.quantity} ${loc.teams.toLowerCase()})';
    }
  }

  Widget _buildResults() {
    if (_results.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.results,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final resultText = _results.join(', ');
                    Clipboard.setData(ClipboardData(text: resultText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.copied),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  tooltip: AppLocalizations.of(context)!.copy,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _results.map((result) {
                  return Chip(
                    label: Text(result),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return RandomGeneratorHistoryWidget(
      historyType: _historyType,
      history: _historyItems,
      title: loc.generationHistory,
      onClearAllHistory: () async {
        await GenerationHistoryService.clearHistory(_historyType);
        await _loadHistory();
      },
      onClearPinnedHistory: () async {
        await GenerationHistoryService.clearPinnedHistory(_historyType);
        await _loadHistory();
      },
      onClearUnpinnedHistory: () async {
        await GenerationHistoryService.clearUnpinnedHistory(_historyType);
        await _loadHistory();
      },
      onCopyItem: _copyHistoryItem,
      onDeleteItem: (index) async {
        await GenerationHistoryService.deleteHistoryItem(_historyType, index);
        await _loadHistory();
      },
      onTogglePin: (index) async {
        await GenerationHistoryService.togglePinHistoryItem(
            _historyType, index);
        await _loadHistory();
      },
      onTapItem: (item) {
        HistoryViewDialog.show(
          context: context,
          item: item,
        );
      },
    );
  }

  void _copyHistoryItem(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBoxOpen) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final loc = AppLocalizations.of(context)!;

    final generatorContent = Column(
      children: [
        _buildListSelector(),
        const SizedBox(height: 16),
        _buildListManager(),
        const SizedBox(height: 16),
        _buildGeneratorOptions(),
        const SizedBox(height: 16),
        _buildResults(),
      ],
    );

    return RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(AppLocalizations.of(context)!),
      historyEnabled: _historyEnabled,
      hasHistory: _historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.listPicker,
    );
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }
}


// children: _state.currentList!.items
//                           .map((item) => Container(
//                                 margin: const EdgeInsets.only(bottom: 4),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
//                                   ),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: ListTile(
//                                   dense: true,
//                                   title: Text(item.value),
//                                   trailing: IconButton(
//                                     icon: const Icon(Icons.delete, size: 20),
//                                     onPressed: () => _removeItem(item.id),
//                                   ),
//                                 ),
//                               ))
//                           .toList(),der.dart'