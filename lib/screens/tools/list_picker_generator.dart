import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/layouts/random_generator_layout.dart';
import 'package:random_please/models/random_models/random_state_models.dart';
import 'package:random_please/models/cloud_template.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/providers/list_picker_generator_state_provider.dart';
import 'package:random_please/utils/generic_dialog_utils.dart';
import 'package:random_please/utils/localization_utils.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/utils/widget_layout_decor_utils.dart';
import 'package:random_please/widgets/generic/option_slider.dart';
import 'package:random_please/widgets/generic/uni_route.dart';
import 'package:random_please/widgets/history_widget.dart';
import 'package:random_please/view_models/list_picker_view_model.dart';
import 'package:random_please/services/cloud_template_service.dart';
import 'package:random_please/widgets/holdable_button.dart';
import 'package:random_please/widgets/tools/import_template_widget.dart';

class ListPickerGeneratorScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;

  const ListPickerGeneratorScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  ConsumerState<ListPickerGeneratorScreen> createState() =>
      _ListPickerGeneratorScreenState();
}

class _ListPickerGeneratorScreenState
    extends ConsumerState<ListPickerGeneratorScreen> {
  late ListPickerViewModel _viewModel;
  late AppLocalizations loc;

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ListPickerViewModel(ref: ref);
    _initData();
  }

  @override
  void didChangeDependencies() {
    loc = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    setState(() {
      _isLoading = true;
    });

    // Use Future.wait to ensure minimum display time for loading
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 300)), // Minimum loading time
      _initDataActual(),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _initDataActual() async {
    await _viewModel.initHive();
    await _viewModel.loadHistory();
  }

  Future<void> _showCreateListDialog() async {
    final TextEditingController nameController = TextEditingController();
    String? errorMessage;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(loc.createListDialog),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 350, maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: loc.enterListName,
                    errorText: errorMessage,
                    counterText: '${nameController.text.length}/30',
                    border: const OutlineInputBorder(),
                  ),
                  maxLength: 30,
                  onChanged: (value) {
                    setDialogState(() {
                      if (value.isEmpty) {
                        errorMessage = loc.listNameRequired;
                      } else if (value.length > 30) {
                        errorMessage = loc.listNameTooLong;
                      } else if (_viewModel.state.savedLists
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
      _viewModel.createNewList(result);
      setState(() {});
    }
  }

  Future<void> _showRenameItemDialog(ListItem item) async {
    final TextEditingController valueController =
        TextEditingController(text: item.value);
    String? errorMessage;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(loc.renameItem),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 350, maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: valueController,
                  decoration: InputDecoration(
                    labelText: loc.itemName,
                    errorText: errorMessage,
                    counterText: '${valueController.text.length}/30',
                    border: const OutlineInputBorder(),
                  ),
                  maxLength: 30,
                  onChanged: (value) {
                    setDialogState(() {
                      if (value.isEmpty) {
                        errorMessage = loc.itemNameRequired;
                      } else if (value.length > 30) {
                        errorMessage = loc.itemNameTooLong;
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
              onPressed: errorMessage == null && valueController.text.isNotEmpty
                  ? () => Navigator.of(context).pop(valueController.text.trim())
                  : null,
              child: Text(loc.save),
            ),
          ],
        ),
      ),
    );

    if (result != null && result != item.value) {
      _viewModel.renameItem(item, result);
      setState(() {});
    }
  }

  Future<void> _showAddBatchDialog() async {
    final colorScheme = Theme.of(context).colorScheme;
    bool dialogShouldContinue = true;

    while (dialogShouldContinue) {
      if (!mounted) return;

      final TextEditingController batchController = TextEditingController();
      String? errorMessage;

      final result = await showDialog<String>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(loc.addBatchItems),
            content: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 400, minHeight: 300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.enterItemsOneLine,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TextField(
                      controller: batchController,
                      decoration: InputDecoration(
                        hintText: loc.batchItemsPlaceholder,
                        border: const OutlineInputBorder(),
                        errorText: errorMessage,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      onChanged: (value) {
                        setDialogState(() {
                          final lines = value
                              .trim()
                              .split('\n')
                              .where((line) => line.trim().isNotEmpty)
                              .toList();
                          if (lines.isEmpty) {
                            errorMessage = loc.enterAtLeastOneItem;
                          } else if (lines.length > 100) {
                            errorMessage = loc.maximumItemsAllowed;
                          } else {
                            errorMessage = null;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.previewItems(batchController.text
                        .trim()
                        .split('\n')
                        .where((line) => line.trim().isNotEmpty)
                        .length),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child:
                    Text(MaterialLocalizations.of(context).cancelButtonLabel),
              ),
              FilledButton(
                onPressed: errorMessage == null &&
                        batchController.text.trim().isNotEmpty
                    ? () =>
                        Navigator.of(context).pop(batchController.text.trim())
                    : null,
                child: Text(loc.addItems),
              ),
            ],
          ),
        ),
      );

      if (result == null) {
        // User cancelled the batch dialog
        dialogShouldContinue = false;
        break;
      }

      if (result.isNotEmpty && _viewModel.state.currentList != null) {
        final lines =
            result.split('\n').where((line) => line.trim().isNotEmpty).toList();

        // Show confirmation dialog
        if (!mounted) return;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.confirmAddItems),
            content: Text(loc.confirmAddItemsMessage(
                lines.length, _viewModel.state.currentList!.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child:
                    Text(MaterialLocalizations.of(context).cancelButtonLabel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(loc.add),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          // Add items using ViewModel
          _viewModel.addBatchItems(lines.map((line) => line.trim()).toList());
          setState(() {});

          // Show success message
          if (mounted) {
            SnackBarUtils.showTyped(context,
                loc.addedItemsSuccessfully(lines.length), SnackBarType.success);
          }
          dialogShouldContinue = false; // End the loop successfully
        } else {
          // If cancel in confirmation, return to batch dialog
          // The loop continues
        }
      } else {
        dialogShouldContinue = false;
      }
    }
  }

  Future<void> _showImportTemplateDialog() async {
    UniRoute.navigate(
      context,
      UniRouteModel(
        title: loc.importTemplate,
        content: ImportTemplateWidget(
          isEmbedded: true,
          onImport: (items, listName) {
            _importItemsFromTemplate(items, listName);
          },
        ),
      ),
    );
  }

  Future<void> _importItemsFromTemplate(
      List<String> items, String listName) async {
    try {
      // Create a new list with specified name
      _viewModel.createNewList(listName);

      // Add all items to the new list in background to avoid blocking UI
      await Future.microtask(() {
        for (final item in items) {
          _viewModel.addItemToCurrentList(item);
        }
      });

      setState(() {});

      if (mounted) {
        SnackBarUtils.showTyped(
            context,
            '${loc.imported} ${items.length} ${loc.items}',
            SnackBarType.success);
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showTyped(
            context, '${loc.error}: $e', SnackBarType.error);
      }
    }
  }

  Future<void> _showTemplateDialog() async {
    // Check internet connection first if Android or Windows
    if (!kIsWeb) {
      final hasInternet = await CloudTemplateService.hasInternetConnection();
      if (!hasInternet) {
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.noInternetConnection),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(loc.pleaseConnectAndTryAgain),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(MaterialLocalizations.of(context).okButtonLabel),
              ),
            ],
          ),
        );
        return;
      }
    }

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => _TemplateDialog(
        onTemplateSelected: (template) {
          _importTemplate(template);
        },
      ),
    );
  }

  Future<void> _importTemplate(CloudTemplate template) async {
    final currentLocale = Localizations.localeOf(context).languageCode;

    // Check if language matches
    if (template.lang != currentLocale) {
      if (!mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(loc.languageNotMatch),
          content: Text(loc.templateNotDesignedForLanguage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(loc.continueButton),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        // Return to template dialog
        if (!mounted) return;
        await _showTemplateDialog();
        return;
      }
    }

    // Show loading dialog
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(loc.importingTemplate),
          ],
        ),
      ),
    );

    try {
      // Import the template in background to avoid blocking UI
      await Future.delayed(const Duration(milliseconds: 100));

      // Create new list immediately
      _viewModel.createNewList(template.name);

      // Add items in batches of 50 to avoid blocking UI
      const batchSize = 50;
      final items = template.values;

      for (int i = 0; i < items.length; i += batchSize) {
        final endIndex =
            (i + batchSize < items.length) ? i + batchSize : items.length;
        final batch = items.sublist(i, endIndex);

        // Add batch and yield to UI thread
        await _viewModel.addBatchItems(batch);
        await Future.delayed(const Duration(
            milliseconds: 10)); // Small delay to allow UI updates
      }

      // Close loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();

      // Show success message
      if (!mounted) return;
      SnackBarUtils.showTyped(context, loc.templateImported, SnackBarType.info);

      // UI will automatically update via Riverpod provider
    } catch (e) {
      // Close loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();

      // Show error message
      if (!mounted) return;
      SnackBarUtils.showTyped(
          context, loc.errorImportingTemplate, SnackBarType.error);
    }
  }

  void _addItemToCurrentList() {
    final text = _itemController.text.trim();
    if (text.isNotEmpty) {
      _viewModel.addItemToCurrentList(text);
      _itemController.clear();
      setState(() {});
    }
  }

  void _removeItem(String itemId) {
    _viewModel.removeItem(itemId);
    setState(() {});
  }

  void _switchToList(CustomList list) {
    _viewModel.switchToList(list);
    setState(() {});
  }

  void _deleteList(CustomList list) async {
    final confirmed = await GenericDialogUtils.showSimpleGenericClearDialog(
      context: context,
      title: loc.deleteList,
      description: loc.deleteListConfirm(list.name),
      onConfirm: () {},
    );

    if (confirmed == true) {
      _viewModel.deleteList(list);
      setState(() {});
    }
  }

  Future<void> _showRenameListDialog(CustomList list) async {
    final TextEditingController nameController =
        TextEditingController(text: list.name);
    String? errorMessage;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(loc.renameList),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 400, maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: loc.enterListName,
                    errorText: errorMessage,
                    counterText: '${nameController.text.length}/30',
                    border: const OutlineInputBorder(),
                  ),
                  maxLength: 30,
                  onChanged: (value) {
                    setDialogState(() {
                      if (value.isEmpty) {
                        errorMessage = loc.listNameRequired;
                      } else if (value.length > 30) {
                        errorMessage = loc.listNameTooLong;
                      } else if (value != list.name &&
                          _viewModel.state.savedLists
                              .any((l) => l.name == value)) {
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
              child: Text(loc.save),
            ),
          ],
        ),
      ),
    );

    if (result != null && result != list.name) {
      _viewModel.renameList(list, result);
      setState(() {});
    }
  }

  void _pickRandomItems() async {
    await _viewModel.pickRandomItems();
    setState(() {});
  }

  Widget _buildListSelector() {
    final colorScheme = Theme.of(context).colorScheme;

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
                      _viewModel.toggleListSelectorCollapse();
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Text(
                          loc.selectList,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        if (_viewModel.state.currentList != null &&
                            _viewModel.state.isListSelectorCollapsed)
                          Expanded(
                            child: Text(
                              '(${_viewModel.state.currentList!.name} - ${_viewModel.state.currentList!.items.length} ${loc.items.toLowerCase()})',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _viewModel.toggleListSelectorCollapse();
                    setState(() {});
                  },
                  icon: Icon(_viewModel.state.isListSelectorCollapsed
                      ? Icons.expand_more
                      : Icons.expand_less),
                  tooltip: _viewModel.state.isListSelectorCollapsed
                      ? loc.expand
                      : loc.collapse,
                ),
                if (!_viewModel.state.isListSelectorCollapsed) ...[
                  IconButton(
                    onPressed: () => _showImportTemplateDialog(),
                    icon: const Icon(Icons.file_download),
                    tooltip: loc.importTemplate,
                  ),
                  IconButton(
                    onPressed: () => _showCreateListDialog(),
                    icon: const Icon(Icons.add),
                    tooltip: loc.createNewList,
                  ),
                ],
              ],
            ),
            if (!_viewModel.state.isListSelectorCollapsed) ...[
              const SizedBox(height: 8),
              if (_viewModel.state.savedLists.isEmpty)
                Text(
                  loc.noListsAvailable,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                )
              else
                Wrap(
                  spacing: 8,
                  children: _viewModel.state.savedLists.map((list) {
                    final isSelected =
                        _viewModel.state.currentList?.id == list.id;
                    return GestureDetector(
                      onLongPress: () => _showRenameListDialog(list),
                      onSecondaryTap: () => _showRenameListDialog(list),
                      child: FilterChip(
                        label: Text('${list.name} (${list.items.length})'),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) _switchToList(list);
                        },
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _deleteList(list),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListManager(AppLocalizations loc) {
    if (_viewModel.state.currentList == null) {
      return SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              loc.selectOrCreateList,
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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _viewModel.toggleListManagerCollapse();
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${loc.manageList}: ${_viewModel.state.currentList!.name}',
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_viewModel.state.isListManagerCollapsed)
                          Text(
                            '(${_viewModel.state.currentList!.items.length})',
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
                    _viewModel.toggleListManagerCollapse();
                    setState(() {});
                  },
                  icon: Icon(_viewModel.state.isListManagerCollapsed
                      ? Icons.expand_more
                      : Icons.expand_less),
                  tooltip: _viewModel.state.isListManagerCollapsed
                      ? loc.expand
                      : loc.collapse,
                ),
              ],
            ),
            if (!_viewModel.state.isListManagerCollapsed) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _itemController,
                      decoration: InputDecoration(
                        labelText: loc.addItem,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addItemToCurrentList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addItemToCurrentList,
                    icon: const Icon(Icons.add),
                    tooltip: loc.addSingleItem,
                  ),
                  IconButton(
                    onPressed: _showAddBatchDialog,
                    icon: const Icon(Icons.add_box),
                    tooltip: loc.addMultipleItems,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_viewModel.state.currentList!.items.isNotEmpty) ...[
                Text(
                  '${loc.items} (${_viewModel.state.currentList!.items.length}):',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWideScreen = constraints.maxWidth > 500;

                    if (isWideScreen) {
                      // Two column layout for wide screens
                      final items = _viewModel.state.currentList!.items;
                      final halfLength = (items.length / 2).ceil();
                      final leftItems = items.take(halfLength).toList();
                      final rightItems = items.skip(halfLength).toList();

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: leftItems.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                return Container(
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
                                  child: GestureDetector(
                                    onLongPress: () =>
                                        _showRenameItemDialog(item),
                                    onSecondaryTap: () =>
                                        _showRenameItemDialog(item),
                                    child: ListTile(
                                      dense: true,
                                      leading: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                      title: Text(item.value),
                                      trailing: IconButton(
                                        icon:
                                            const Icon(Icons.delete, size: 20),
                                        onPressed: () => _removeItem(item.id),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: rightItems.asMap().entries.map((entry) {
                                final index = entry.key + halfLength;
                                final item = entry.value;
                                return Container(
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
                                  child: GestureDetector(
                                    onLongPress: () =>
                                        _showRenameItemDialog(item),
                                    onSecondaryTap: () =>
                                        _showRenameItemDialog(item),
                                    child: ListTile(
                                      dense: true,
                                      leading: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                      title: Text(item.value),
                                      trailing: IconButton(
                                        icon:
                                            const Icon(Icons.delete, size: 20),
                                        onPressed: () => _removeItem(item.id),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Single column layout for narrow screens
                      return Column(
                        children: _viewModel.state.currentList!.items
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return Container(
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
                            child: GestureDetector(
                              onLongPress: () => _showRenameItemDialog(item),
                              onSecondaryTap: () => _showRenameItemDialog(item),
                              child: ListTile(
                                dense: true,
                                leading: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                title: Text(item.value),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  onPressed: () => _removeItem(item.id),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ] else if (_viewModel.state.currentList!.items.isNotEmpty) ...[
              // Collapsed state with SingleChildScrollView and max height only for items list
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _itemController,
                      decoration: InputDecoration(
                        labelText: loc.addItem,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addItemToCurrentList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addItemToCurrentList,
                    icon: const Icon(Icons.add),
                    tooltip: loc.addSingleItem,
                  ),
                  IconButton(
                    onPressed: _showAddBatchDialog,
                    icon: const Icon(Icons.add_box),
                    tooltip: loc.addMultipleItems,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${loc.items} (${_viewModel.state.currentList!.items.length}):',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWideScreen = constraints.maxWidth > 500;

                      if (isWideScreen) {
                        // Two column layout for wide screens
                        final items = _viewModel.state.currentList!.items;
                        final halfLength = (items.length / 2).ceil();
                        final leftItems = items.take(halfLength).toList();
                        final rightItems = items.skip(halfLength).toList();

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children:
                                    leftItems.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  return Container(
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
                                    child: GestureDetector(
                                      onLongPress: () =>
                                          _showRenameItemDialog(item),
                                      onSecondaryTap: () =>
                                          _showRenameItemDialog(item),
                                      child: ListTile(
                                        dense: true,
                                        leading: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        title: Text(item.value),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 20),
                                          onPressed: () => _removeItem(item.id),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children:
                                    rightItems.asMap().entries.map((entry) {
                                  final index = entry.key + halfLength;
                                  final item = entry.value;
                                  return Container(
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
                                    child: GestureDetector(
                                      onLongPress: () =>
                                          _showRenameItemDialog(item),
                                      onSecondaryTap: () =>
                                          _showRenameItemDialog(item),
                                      child: ListTile(
                                        dense: true,
                                        leading: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        title: Text(item.value),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete,
                                              size: 20),
                                          onPressed: () => _removeItem(item.id),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Single column layout for narrow screens
                        return Column(
                          children: _viewModel.state.currentList!.items
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return Container(
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
                              child: GestureDetector(
                                onLongPress: () => _showRenameItemDialog(item),
                                onSecondaryTap: () =>
                                    _showRenameItemDialog(item),
                                child: ListTile(
                                  dense: true,
                                  leading: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  title: Text(item.value),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, size: 20),
                                    onPressed: () => _removeItem(item.id),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratorOptions() {
    final maxItems = _viewModel.state.currentList?.items.length ?? 0;
    final colorScheme = Theme.of(context).colorScheme;

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
                        color: colorScheme.onSurfaceVariant,
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

    switch (_viewModel.state.mode) {
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

    final safeQuantity =
        _viewModel.state.quantity.clamp(minQuantity, maxQuantity);
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
              child: Wrap(
                spacing: 8,
                children: List.generate(3, (i) {
                  final mode = ListPickerMode.values[i];
                  final isSelected = _viewModel.state.mode == mode;
                  final enabled =
                      (mode == ListPickerMode.random && maxItems >= 2) ||
                          (mode == ListPickerMode.shuffle && maxItems >= 2) ||
                          (mode == ListPickerMode.team && maxItems >= 3);
                  final label = mode == ListPickerMode.random
                      ? loc.modeRandom
                      : mode == ListPickerMode.shuffle
                          ? loc.modeShuffle
                          : loc.modeTeam;
                  final tooltip = mode == ListPickerMode.random
                      ? loc.modeRandomDesc
                      : mode == ListPickerMode.shuffle
                          ? loc.modeShuffleDesc
                          : loc.modeTeamDesc;
                  return Tooltip(
                    message: tooltip,
                    child: ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      onSelected: enabled
                          ? (selected) {
                              if (selected) {
                                _viewModel.updateMode(mode);
                                setState(() {});
                              }
                            }
                          : null,
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 8),

            // Quantity Control - Use TextBox for large lists (>40 items), Slider for smaller ones
            if (maxItems > 0)
              maxItems > 40
                  ? _buildQuantityTextInput(
                      loc, minQuantity, maxQuantity, safeQuantity)
                  : OptionSlider<int>(
                      label: _viewModel.state.mode == ListPickerMode.team
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
                        _viewModel.updateQuantity(value);
                        setState(() {});
                      },
                      layout: OptionSliderLayout.none,
                    )
            else
              SizedBox(
                width: double.infinity,
                child: Text(
                  loc.selectOrCreateList,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
                onPressed: _viewModel.state.currentList != null &&
                        _viewModel.state.currentList!.items.isNotEmpty
                    ? _pickRandomItems
                    : null,
                icon: Icon(
                  _viewModel.state.mode == ListPickerMode.random
                      ? Icons.shuffle
                      : _viewModel.state.mode == ListPickerMode.shuffle
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
    switch (_viewModel.state.mode) {
      case ListPickerMode.random:
        return loc.generateRandom;
      case ListPickerMode.shuffle:
        return loc.modeShuffle;
      case ListPickerMode.team:
        return '${loc.modeTeam} (${_viewModel.state.quantity} ${loc.teams.toLowerCase()})';
    }
  }

  Widget _buildResults() {
    if (_viewModel.results.isEmpty) return const SizedBox.shrink();

    final currentState = _viewModel.state;
    final isTeamMode = currentState.mode == ListPickerMode.team;

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
                    loc.results,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final resultText = _viewModel.results.join('; ');
                    Clipboard.setData(ClipboardData(text: resultText));
                    SnackBarUtils.showTyped(
                        context, loc.copied, SnackBarType.info);
                  },
                  icon: const Icon(Icons.copy),
                  tooltip: loc.copy,
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
              child: isTeamMode ? _buildTeamResults() : _buildNormalResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalResults() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _viewModel.results.map((result) {
        return Chip(
          label: Text(result),
        );
      }).toList(),
    );
  }

  Widget _buildTeamResults() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _viewModel.results.asMap().entries.map((entry) {
          final teamIndex = entry.key;
          final result = entry.value;

          // Parse team result: "Team 1: item1, item2, item3"
          final teamParts = result.split(': ');
          final teamName =
              teamParts.length > 1 ? teamParts[0] : 'Team ${teamIndex + 1}';
          final teamMembers =
              teamParts.length > 1 ? teamParts[1].split(', ') : [result];

          return Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Team header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    teamName,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                // Team members in column with numbering
                ...teamMembers.asMap().entries.map((memberEntry) {
                  final memberIndex = memberEntry.key;
                  final member = memberEntry.value.trim();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Center(
                            child: Text(
                              '${memberIndex + 1}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            member,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistoryWidget(AppLocalizations loc) {
    return HistoryWidget(
      type: ListPickerViewModel.historyType,
      title: loc.generationHistory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    // Watch state changes to trigger rebuilds
    ref.watch(listPickerGeneratorStateManagerProvider);

    final generatorContent = Column(
      children: [
        _buildListSelector(),
        const SizedBox(height: 16),
        _buildListManager(loc),
        const SizedBox(height: 16),
        _buildGeneratorOptions(),
        const SizedBox(height: 16),
        _buildResults(),
      ],
    );

    final mainWidget = RandomGeneratorLayout(
      generatorContent: generatorContent,
      historyWidget: _buildHistoryWidget(loc),
      historyEnabled: _viewModel.historyEnabled,
      hasHistory: _viewModel.historyEnabled,
      isEmbedded: widget.isEmbedded,
      title: loc.listPicker,
    );

    return Stack(
      children: [
        mainWidget,

        // Loading overlay when initializing
        if (_isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      loc.loading,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${loc.pleaseWait}...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuantityTextInput(AppLocalizations loc, int minQuantity,
      int maxQuantity, int currentQuantity) {
    final colorScheme = Theme.of(context).colorScheme;

    // Initialize controller with current value if not already set
    if (_quantityController.text.isEmpty ||
        int.tryParse(_quantityController.text) != currentQuantity) {
      _quantityController.text = currentQuantity.toString();
    }

    final label =
        _viewModel.state.mode == ListPickerMode.team ? loc.teams : loc.quantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '${loc.enter} $label ($minQuantity-$maxQuantity)',
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  final intValue = int.tryParse(value);
                  if (intValue != null &&
                      intValue >= minQuantity &&
                      intValue <= maxQuantity) {
                    _viewModel.updateQuantity(intValue);
                    setState(() {});
                  }
                },
                onSubmitted: (value) {
                  final intValue = int.tryParse(value);
                  if (intValue != null) {
                    final clampedValue =
                        intValue.clamp(minQuantity, maxQuantity);
                    _quantityController.text = clampedValue.toString();
                    _viewModel.updateQuantity(clampedValue);
                    setState(() {});
                  } else {
                    // Reset to current value if invalid
                    _quantityController.text = currentQuantity.toString();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            HoldableButton(
              tooltip: loc.increase,
              enabled: currentQuantity < maxQuantity,
              onTap: () {
                final newValue = currentQuantity + 1;
                _quantityController.text = newValue.toString();
                _viewModel.updateQuantity(newValue);
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add,
                  color: colorScheme.onPrimary,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(width: 8),
            HoldableButton(
              tooltip: loc.decrease,
              enabled: currentQuantity > minQuantity,
              onTap: () {
                final newValue = currentQuantity - 1;
                _quantityController.text = newValue.toString();
                _viewModel.updateQuantity(newValue);
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.remove,
                  color: colorScheme.onPrimary,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${loc.range}: $minQuantity-$maxQuantity',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _TemplateDialog extends StatefulWidget {
  final Function(CloudTemplate) onTemplateSelected;

  const _TemplateDialog({
    required this.onTemplateSelected,
  });

  @override
  State<_TemplateDialog> createState() => _TemplateDialogState();
}

class _TemplateDialogState extends State<_TemplateDialog> {
  Future<List<CloudTemplate>>? _templatesFuture;
  CloudTemplate? _selectedTemplate;

  @override
  void initState() {
    super.initState();
    _templatesFuture = CloudTemplateService.fetchCloudTemplates();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(loc.cloudTemplates),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: FutureBuilder<List<CloudTemplate>>(
            future: _templatesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(loc.fetchingTemplates),
                  ],
                );
              }

              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                  ],
                );
              }

              final templates = snapshot.data ?? [];
              if (templates.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(loc.noTemplatesAvailable),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.selectTemplate),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: templates.length,
                      itemBuilder: (context, index) {
                        final template = templates[index];
                        final isSelected = _selectedTemplate == template;

                        return Card(
                          color:
                              isSelected ? colorScheme.primaryContainer : null,
                          child: ListTile(
                            title: Text(template.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${loc.languageCode}: ${LocalizationUtils.getLanguageNameFromCode(template.lang)}'),
                                Text(loc.itemsCount(template.values.length)),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                _selectedTemplate = template;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: _selectedTemplate != null
              ? () {
                  Navigator.of(context).pop();
                  widget.onTemplateSelected(_selectedTemplate!);
                }
              : null,
          child: Text(loc.import),
        ),
      ],
    );
  }
}
