import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/providers/history_provider.dart';
import 'package:random_please/services/generation_history_service.dart';
import 'package:random_please/utils/generic_dialog_utils.dart';
import 'package:random_please/utils/history_view_dialog.dart';
import 'package:random_please/utils/snackbar_utils.dart';
import 'package:random_please/widgets/generic/generic_context_menu.dart';

class HistoryWidget extends ConsumerStatefulWidget {
  final String type;
  final String title;

  const HistoryWidget({
    Key? key,
    required this.type,
    required this.title,
  }) : super(key: key);

  @override
  ConsumerState<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends ConsumerState<HistoryWidget> {
  Set<int> confirmDeleteIndices =
      {}; // Track which items are in confirm delete state
  late AppLocalizations loc;

  @override
  void initState() {
    super.initState();
    // Load history when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).loadHistoryForType(widget.type);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loc = AppLocalizations.of(context)!;
  }

  bool get isMobile => MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    final historyItems = ref.watch(historyForTypeProvider(widget.type));
    final isHistoryEnabled = ref.watch(historyEnabledProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (!isHistoryEnabled) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(loc.noHistoryYet),
        ),
      );
    }

    if (historyItems.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                loc.noHistoryYet,
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                loc.noHistoryMessage,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: textTheme.titleMedium,
                ),
                _buildClearButton(),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: historyItems.length,
                itemBuilder: (context, index) {
                  final item = historyItems[index];
                  final isConfirmingDelete =
                      confirmDeleteIndices.contains(index);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: isConfirmingDelete ? Colors.red.shade50 : null,
                    child: ListTile(
                      dense: true,
                      title: Text(
                        item.value,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isConfirmingDelete ? Colors.red.shade700 : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _formatDate(item.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isConfirmingDelete ? Colors.red.shade600 : null,
                        ),
                      ),
                      trailing: _buildTrailingActions(
                          index, item, isConfirmingDelete),
                      onTap: isConfirmingDelete
                          ? null
                          : () => _showItemDetailDialog(item),
                      tileColor: item.isPinned
                          ? Colors.yellow.withValues(alpha: 0.1)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTapUp: (details) =>
          _showClearOptionsContextMenu(details.globalPosition),
      onLongPress: () =>
          _showClearAllHistoryDialog(context, true), // Long press
      onSecondaryTap: () =>
          _showClearAllHistoryDialog(context, true), // Right click
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.clear_all, size: 16, color: Colors.red.shade700),
              const SizedBox(width: 4),
              Text(
                '${loc.clear}...',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showClearAllHistoryDialog(
      BuildContext context, bool containsPinned) async {
    final historyNotifier = ref.read(historyProvider.notifier);
    final confirmed = await GenericDialogUtils.showSimpleGenericClearDialog(
      context: context,
      onConfirm: () => historyNotifier.clearHistory(widget.type),
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
    final historyNotifier = ref.read(historyProvider.notifier);
    final confirmed = await GenericDialogUtils.showSimpleGenericClearDialog(
      context: context,
      onConfirm: () => historyNotifier.clearPinnedHistory(widget.type),
      title: loc.clearPinnedItems,
      description: loc.clearPinnedItemsDesc,
    );

    if (confirmed == true && context.mounted) {
      SnackBarUtils.showTyped(
          context, loc.pinnedHistoryCleared, SnackBarType.info);
    }
  }

  Future<void> _showClearUnpinnedHistoryDialog(BuildContext context) async {
    final historyNotifier = ref.read(historyProvider.notifier);
    final confirmed = await GenericDialogUtils.showSimpleGenericClearDialog(
      context: context,
      onConfirm: () => historyNotifier.clearUnpinnedHistory(widget.type),
      title: loc.clearUnpinnedItems,
      description: loc.clearUnpinnedItemsDesc,
    );

    if (confirmed == true && context.mounted) {
      SnackBarUtils.showTyped(
          context, loc.unpinnedHistoryCleared, SnackBarType.info);
    }
  }

  void _showClearOptionsContextMenu(Offset position) {
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

  Widget _buildTrailingActions(
      int index, dynamic item, bool isConfirmingDelete) {
    if (isConfirmingDelete) {
      // Trong trạng thái confirm delete, chỉ hiển thị nút xóa thay thế menu
      return IconButton(
        icon: const Icon(Icons.delete_forever, size: 18),
        onPressed: () => _confirmDelete(index),
        tooltip: loc.confirmDelete,
        color: Colors.red.shade700,
      );
    } else if (isMobile) {
      // Mobile: chỉ hiển thị nút menu
      return PopupMenuButton<String>(
        onSelected: (value) => _onItemAction(value, index),
        icon: const Icon(Icons.more_vert, size: 16),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'pin',
            child: Row(
              children: [
                Icon(
                  item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(item.isPinned ? loc.unpinHistoryItem : loc.pinHistoryItem),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'copy',
            child: Row(
              children: [
                const Icon(Icons.copy, size: 16),
                const SizedBox(width: 8),
                Text(loc.copyToClipboard),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete, size: 16, color: Colors.red),
                const SizedBox(width: 8),
                Text(loc.deleteHistoryItem,
                    style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      );
    } else {
      // Desktop: hiển thị đủ 3 nút
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nút ghim
          IconButton(
            icon: Icon(
              item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              size: 16,
            ),
            onPressed: () => _togglePin(index),
            tooltip: item.isPinned ? loc.unpinHistoryItem : loc.pinHistoryItem,
          ),
          // Nút copy
          IconButton(
            icon: const Icon(Icons.copy, size: 16),
            onPressed: () => _copyToClipboard(item.value),
            tooltip: loc.copyToClipboard,
          ),
          // Nút xóa
          IconButton(
            icon: const Icon(Icons.delete, size: 16),
            onPressed: () => _requestDelete(index),
            tooltip: loc.deleteHistoryItem,
            color: Colors.red.shade600,
          ),
        ],
      );
    }
  }

  void _onItemAction(String action, int index) {
    final historyItems = ref.read(historyForTypeProvider(widget.type));
    final item = historyItems[index];

    switch (action) {
      case 'pin':
        _togglePin(index);
        break;
      case 'copy':
        _copyToClipboard(item.value);
        break;
      case 'delete':
        _requestDelete(index);
        break;
    }
  }

  void _requestDelete(int index) {
    setState(() {
      confirmDeleteIndices.add(index);
    });

    // Auto cancel after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && confirmDeleteIndices.contains(index)) {
        _cancelDelete(index);
      }
    });
  }

  void _cancelDelete(int index) {
    setState(() {
      confirmDeleteIndices.remove(index);
    });
  }

  void _confirmDelete(int index) async {
    setState(() {
      confirmDeleteIndices.remove(index);
    });

    final historyNotifier = ref.read(historyProvider.notifier);
    await historyNotifier.deleteHistoryItem(widget.type, index);
  }

  void _togglePin(int index) async {
    final historyNotifier = ref.read(historyProvider.notifier);
    await historyNotifier.togglePinHistoryItem(widget.type, index);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    SnackBarUtils.showTyped(context, '${loc.copied} $text', SnackBarType.info);
  }

  void _showItemDetailDialog(GenerationHistoryItem item) {
    HistoryViewDialog.show(
      context: context,
      item: item,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
