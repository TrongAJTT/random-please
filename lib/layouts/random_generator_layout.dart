import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/services/settings_service.dart';
import 'package:random_please/utils/generic_dialog_utils.dart';
import 'package:random_please/utils/localization_utils.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/widgets/generic/generic_context_menu.dart';
import 'package:random_please/widgets/generic/icon_button_list.dart';

/// Typedef for double-tap confirmation callback
typedef DoubleConfirmCallback = void Function(int index);

/// Helper class for double-tap confirmation logic
class DoubleConfirmHelper {
  int? _pendingIndex;
  VoidCallback? _clearPendingCallback;

  /// Handle double-tap confirmation for any action
  void handleConfirmationTap({
    required BuildContext context,
    required int index,
    required DoubleConfirmCallback onConfirm,
    required String confirmMessage,
    required String successMessage,
    required VoidCallback onStateChange,
    Duration timeout = const Duration(seconds: 2),
  }) {
    if (_pendingIndex == index) {
      // Second tap - confirm action
      onConfirm(index);
      _clearPending();
      onStateChange();
      SnackBarUtils.showTyped(
        context,
        successMessage,
        SnackBarType.success,
      );
    } else {
      // First tap - show confirmation message
      _pendingIndex = index;
      onStateChange();
      SnackBarUtils.showTyped(
        context,
        confirmMessage,
        SnackBarType.warning,
      );

      // Clear pending action after timeout
      _clearPendingCallback?.call();
      _clearPendingCallback = () {
        if (_pendingIndex == index) {
          _clearPending();
          onStateChange();
        }
      };

      Future.delayed(timeout, () {
        _clearPendingCallback?.call();
        _clearPendingCallback = null;
      });
    }
  }

  /// Check if an index is pending confirmation
  bool isPending(int index) => _pendingIndex == index;

  /// Clear pending confirmation
  void _clearPending() {
    _pendingIndex = null;
  }

  /// Dispose resources
  void dispose() {
    _clearPendingCallback = null;
    _pendingIndex = null;
  }
}

/// Generic layout widget for all random generators to ensure consistency
class RandomGeneratorLayout extends StatefulWidget {
  final Widget generatorContent;
  final Widget? historyWidget;
  final bool historyEnabled;
  final bool hasHistory;
  final bool isEmbedded;
  final String title;

  const RandomGeneratorLayout({
    super.key,
    required this.generatorContent,
    this.historyWidget,
    required this.historyEnabled,
    required this.hasHistory,
    required this.isEmbedded,
    required this.title,
  });

  @override
  State<RandomGeneratorLayout> createState() => _RandomGeneratorLayoutState();
}

class _RandomGeneratorLayoutState extends State<RandomGeneratorLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _compactTabLayout = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final compactTabLayout = await SettingsService.getCompactTabLayout();
    if (mounted) {
      setState(() {
        _compactTabLayout = compactTabLayout;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 1200;

    Widget content;

    if (isLargeScreen) {
      if (widget.historyEnabled &&
          widget.hasHistory &&
          widget.historyWidget != null) {
        // Desktop with history: 3:2 ratio, history full height
        content = Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Generator content: 60% width (3/5)
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: widget.generatorContent,
              ),
            ),
            const SizedBox(width: 24),
            // History widget: 40% width (2/5), full height
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                child: widget.historyWidget!,
              ),
            ),
          ],
        );
      } else {
        // Desktop without history: Generator centered, 60% width
        content = Row(
          children: [
            // Left spacer: 20%
            const Expanded(flex: 1, child: SizedBox()),
            // Generator content: 60%
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: widget.generatorContent,
              ),
            ),
            // Right spacer: 20%
            const Expanded(flex: 1, child: SizedBox()),
          ],
        );
      }
    } else {
      // Mobile: Tab layout
      if (widget.historyEnabled &&
          widget.hasHistory &&
          widget.historyWidget != null) {
        final loc = AppLocalizations.of(context)!;
        content = Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  icon: _compactTabLayout ? null : const Icon(Icons.casino),
                  text: loc.random,
                ),
                Tab(
                  icon: _compactTabLayout ? null : const Icon(Icons.history),
                  text: loc.generationHistory,
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Random tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: widget.generatorContent,
                  ),
                  // History tab
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: widget.historyWidget!,
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        // Mobile without history: Single scroll view
        content = SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: widget.generatorContent,
        );
      }
    }

    // Return either the content directly (if embedded) or wrapped in a Scaffold
    if (widget.isEmbedded) {
      // When embedded, wrap TabBar content in Material if needed
      if (!isLargeScreen &&
          widget.historyEnabled &&
          widget.hasHistory &&
          widget.historyWidget != null) {
        return Material(
          type: MaterialType.transparency,
          child: content,
        );
      }
      return content;
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
        ),
        body: content,
      );
    }
  }
}

typedef CustomHeaderBuilder = Widget Function(List<dynamic> history, int index);

/// Generic history widget builder for consistency
class RandomGeneratorHistoryWidget extends StatefulWidget {
  final String historyType;
  final List<GenerationHistoryItem> history;
  final String title;
  final CustomHeaderBuilder? customHeader;
  final VoidCallback onClearAllHistory;
  final VoidCallback onClearPinnedHistory;
  final VoidCallback onClearUnpinnedHistory;
  final void Function(String) onCopyItem;
  final void Function(int index) onDeleteItem;
  final void Function(int index) onTogglePin;

  const RandomGeneratorHistoryWidget({
    super.key,
    required this.historyType,
    required this.history,
    required this.title,
    required this.onClearAllHistory,
    required this.onClearPinnedHistory,
    required this.onClearUnpinnedHistory,
    required this.onCopyItem,
    required this.onDeleteItem,
    required this.onTogglePin,
    this.customHeader,
  });

  @override
  State<RandomGeneratorHistoryWidget> createState() =>
      _RandomGeneratorHistoryWidgetState();
}

class _RandomGeneratorHistoryWidgetState
    extends State<RandomGeneratorHistoryWidget> {
  late DoubleConfirmHelper _confirmHelper;
  late AppLocalizations loc;

  @override
  void initState() {
    super.initState();
    _confirmHelper = DoubleConfirmHelper();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loc = AppLocalizations.of(context)!;
  }

  @override
  void dispose() {
    _confirmHelper.dispose();
    super.dispose();
  }

  void _handleDeleteTap(int index) {
    final loc = AppLocalizations.of(context)!;

    _confirmHelper.handleConfirmationTap(
      context: context,
      index: index,
      onConfirm: widget.onDeleteItem,
      confirmMessage: loc.tapDeleteAgainToConfirm,
      successMessage: loc.historyItemDeleted,
      onStateChange: () => setState(() {}),
    );
  }

  void _handlePinTap(int index) {
    final loc = AppLocalizations.of(context)!;
    final item = widget.history[index];
    final isPinned = item.isPinned;

    widget.onTogglePin(index);

    SnackBarUtils.showTyped(
      context,
      isPinned ? loc.historyItemUnpinned : loc.historyItemPinned,
      SnackBarType.info,
    );
  }

  List<IconButtonListItem> _buildIconButon({
    required dynamic item,
    required int index,
    required bool isPinned,
    required bool isPendingDelete,
  }) {
    return [
      IconButtonListItem(
        icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
        color: isPinned ? Colors.orange : null,
        onPressed: () => _handlePinTap(index),
        label: isPinned ? loc.unpinHistoryItem : loc.pinHistoryItem,
      ),
      IconButtonListItem(
        icon: Icons.copy,
        onPressed: () => widget.onCopyItem(item.value.toString()),
        label: loc.copyToClipboard,
      ),
      IconButtonListItem(
        icon: isPendingDelete ? Icons.warning : Icons.delete,
        color: isPendingDelete ? Colors.red : null,
        onPressed: () => _handleDeleteTap(index),
        label: isPendingDelete ? loc.confirmDelete : loc.deleteHistoryItem,
      ),
    ];
  }

  Widget _buildListItem(
      GenerationHistoryItem item, BuildContext context, int index) {
    final width = MediaQuery.of(context).size.width;

    // Format timestamp based on locale
    String formattedTimestamp = LocalizationUtils.formatDateTime(
        context: context,
        dateTime: item.timestamp,
        formatType: DateTimeFormatType.exceptSec);
    final isPendingDelete = _confirmHelper.isPending(index);
    final isPinned = item.isPinned;

    final iconButtons = _buildIconButon(
      item: item,
      index: index,
      isPinned: isPinned,
      isPendingDelete: isPendingDelete,
    );
    final visibleCount = width > 480 ? iconButtons.length : 0;

    // Item builder
    return ListTile(
        dense: true,
        leading: widget.customHeader?.call(widget.history, index),
        tileColor: isPendingDelete ? Colors.red.withValues(alpha: 0.1) : null,
        title: Text(
          item.value.toString(),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: isPendingDelete ? Colors.red : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          loc.generatedAtTime(formattedTimestamp),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color:
                    isPendingDelete ? Colors.red.withValues(alpha: 0.7) : null,
              ),
        ),
        trailing: IconButtonList(
          buttons: iconButtons,
          visibleCount: visibleCount,
          spacing: 4,
        ));
  }

  Future<void> _showClearAllHistoryDialog(
      BuildContext context, bool containsPinned) async {
    final confirmed = await GenericDialogUtils.showSimpleGenericClearDialog(
      context: context,
      onConfirm: widget.onClearAllHistory,
      title: containsPinned ? loc.clearAllItems : loc.confirmClearHistory,
      description: containsPinned
          ? loc.confirmClearAllHistory
          : loc.confirmClearHistoryMessage,
    );

    if (confirmed == true && context.mounted) {
      SnackBarUtils.showTyped(context, loc.historyCleared, SnackBarType.info);
    }
  }

  Future<void> _showClearPinnedHistoryDialog(BuildContext context) async {
    final confirmed = await GenericDialogUtils.showSimpleGenericClearDialog(
      context: context,
      onConfirm: widget.onClearPinnedHistory,
      title: loc.clearPinnedItems,
      description: loc.clearPinnedItemsDesc,
    );

    if (confirmed == true && context.mounted) {
      SnackBarUtils.showTyped(
          context, loc.pinnedHistoryCleared, SnackBarType.info);
    }
  }

  Future<void> _showClearUnpinnedHistoryDialog(BuildContext context) async {
    final confirmed = await GenericDialogUtils.showSimpleGenericClearDialog(
      context: context,
      onConfirm: widget.onClearUnpinnedHistory,
      title: loc.clearUnpinnedItems,
      description: loc.clearUnpinnedItemsDesc,
    );

    if (confirmed == true && context.mounted) {
      SnackBarUtils.showTyped(
          context, loc.unpinnedHistoryCleared, SnackBarType.info);
    }
  }

  Future<void> _showClearOptionsContextMenu(Offset position) async {
    GenericContextMenu.show(
      context: context,
      position: position,
      actions: [
        OptionItem(
            label: loc.clearUnpinnedItems,
            icon: Icons.delete,
            onTap: () => _showClearUnpinnedHistoryDialog(context)),
        OptionItem(
            label: loc.clearPinnedItems,
            icon: Icons.push_pin,
            onTap: () => _showClearPinnedHistoryDialog(context)),
        OptionItem(
          label: loc.clearAllItems,
          icon: Icons.delete_sweep,
          onTap: () => _showClearAllHistoryDialog(context, true),
        ),
      ],
      desktopDialogWidth: 240,
    );
  }

  Widget _buildClearButton() {
    final fullClearShow = widget.history.any((item) => item.isPinned);

    return fullClearShow
        ? GestureDetector(
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${loc.clear}...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                )),
            onTapUp: (d) => _showClearOptionsContextMenu(d.globalPosition),
            onLongPressStart: (d) => _showClearAllHistoryDialog(context, true),
            onSecondaryTapDown: (d) =>
                _showClearAllHistoryDialog(context, true),
          )
        : TextButton(
            onPressed: () => _showClearAllHistoryDialog(context, false),
            child: Text(loc.clearHistory),
          );
  }

  Widget _buildHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              _buildClearButton()
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _buildClearButton()
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.history.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              loc.noHistoryYet,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              loc.noHistoryMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = MediaQuery.of(context).size.width < 1200;

        if (isMobile) {
          // Mobile in tab: Use full height with Expanded ListView
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const Divider(),
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.history.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          _buildListItem(widget.history[index], context, index),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Desktop: Use Column with Expanded for full height
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const Divider(),
                  Expanded(
                    child: ListView.separated(
                      itemCount: widget.history.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          _buildListItem(widget.history[index], context, index),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
