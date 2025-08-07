import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/services/tool_order_service.dart';
import 'package:random_please/services/random_tools_manager.dart';

class ToolOrderingScreen extends StatefulWidget {
  final bool isEmbedded;

  const ToolOrderingScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<ToolOrderingScreen> createState() => _ToolOrderingScreenState();
}

class _ToolOrderingScreenState extends State<ToolOrderingScreen> {
  List<ToolItem> _tools = [];
  bool _loading = true;
  bool _hasChanges = false;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _hasInitialized = true;
      _loadTools();
    }
  }

  Future<void> _loadTools() async {
    final loc = AppLocalizations.of(context)!;
    final orderedTools = await RandomToolsManager.getOrderedTools(loc);

    setState(() {
      _tools = orderedTools.toList();
      _loading = false;
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _tools.removeAt(oldIndex);
      _tools.insert(newIndex, item);
      _hasChanges = true;
    });
  }

  Future<void> _saveOrder() async {
    final toolIds = _tools.map((tool) => tool.id).toList();
    await ToolOrderService.saveToolOrder(toolIds);

    if (mounted) {
      Navigator.of(context)
          .pop(true); // Return true to indicate changes were saved
    }
  }

  void _resetToDefault() async {
    await ToolOrderService.resetToDefault();
    setState(() {
      _hasInitialized = false;
      _loading = true;
    });
    await _loadTools();
    setState(() {
      _hasChanges = true;
    });
  }

  void _cancel() {
    Navigator.of(context).pop(false); // Return false to indicate no changes
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    Widget content = Scaffold(
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              title: Text(loc.arrangeTools),
              elevation: 0,
            ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Instructions
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            loc.howToArrangeTools,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loc.dragAndDropToReorder,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),

                // Tool list
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _tools.length,
                    onReorder: _onReorder,
                    itemBuilder: (context, index) {
                      final tool = _tools[index];
                      return _buildToolCard(tool, index);
                    },
                  ),
                ),

                // Action buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Default button
                      TextButton.icon(
                        onPressed: _resetToDefault,
                        icon: const Icon(Icons.restore),
                        label: Text(loc.defaultOrder),
                      ),

                      const Spacer(),

                      // Cancel button
                      OutlinedButton(
                        onPressed: _cancel,
                        child: Text(loc.cancel),
                      ),

                      const SizedBox(width: 12),

                      // Save button
                      FilledButton.icon(
                        onPressed: _hasChanges ? _saveOrder : null,
                        icon: const Icon(Icons.save),
                        label: Text(loc.save),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );

    if (widget.isEmbedded) {
      return content;
    }

    return content;
  }

  Widget _buildToolCard(ToolItem tool, int index) {
    return Card(
      key: ValueKey(tool.id),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Order number
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Tool icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: tool.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                tool.icon,
                color: tool.color,
                size: 24,
              ),
            ),
          ],
        ),
        title: Text(
          tool.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          tool.subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        trailing: Icon(
          Icons.drag_handle,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
