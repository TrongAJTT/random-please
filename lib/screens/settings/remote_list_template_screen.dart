import 'package:flutter/material.dart';
import 'package:random_please/l10n/app_localizations.dart';
import 'package:random_please/services/remote_list_template_service.dart';

class RemoteListTemplateScreen extends StatefulWidget {
  final bool isEmbedded;

  const RemoteListTemplateScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  State<RemoteListTemplateScreen> createState() =>
      _RemoteListTemplateScreenState();
}

class _RemoteListTemplateScreenState extends State<RemoteListTemplateScreen> {
  List<RemoteListTemplateItem> _sources = [];
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
      _loadSources();
    }
  }

  Future<void> _loadSources() async {
    final sources = await RemoteListTemplateService.getAllSourcesWithState();

    setState(() {
      _sources = sources;
      _loading = false;
    });
  }

  void _toggleVisibility(int index) {
    setState(() {
      _sources[index] = _sources[index].copyWith(
        isVisible: !_sources[index].isVisible,
      );
      _hasChanges = true;
    });
  }

  void _addCustomSource() {
    showDialog(
      context: context,
      builder: (context) => _AddSourceDialog(
        onAdd: (url) {
          setState(() {
            _sources.add(RemoteListTemplateItem(
              url: url,
              isVisible: true,
              isDefault: false,
            ));
            _hasChanges = true;
          });
        },
      ),
    );
  }

  void _editSource(int index) {
    final source = _sources[index];
    if (source.isDefault) return; // Cannot edit default source

    showDialog(
      context: context,
      builder: (context) => _EditSourceDialog(
        initialUrl: source.url,
        onSave: (url) {
          setState(() {
            _sources[index] = source.copyWith(url: url);
            _hasChanges = true;
          });
        },
      ),
    );
  }

  void _removeSource(int index) {
    final source = _sources[index];
    if (source.isDefault) return; // Cannot remove default source

    setState(() {
      _sources.removeAt(index);
      _hasChanges = true;
    });
  }

  Future<void> _saveChanges() async {
    await RemoteListTemplateService.saveSourcesWithState(_sources);

    if (mounted) {
      Navigator.of(context)
          .pop(true); // Return true to indicate changes were saved
    }
  }

  Future<void> _resetToDefault() async {
    final confirmed = await _showResetConfirmDialog();
    if (confirmed != true) return;

    await RemoteListTemplateService.resetToDefault();
    setState(() {
      _hasInitialized = false;
      _loading = true;
    });
    await _loadSources();
    setState(() {
      _hasChanges = true;
    });
  }

  Future<bool?> _showResetConfirmDialog() async {
    final loc = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.reset),
        content: const Text(
            'This will remove all custom sources and enable the default source. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(loc.reset),
          ),
        ],
      ),
    );
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
              title: const Text('Remote List Template Source'),
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
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                    ),
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
                            'Remote List Template Sources',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage list template sources for Pick From List tool. You can show/hide, add, edit, or remove custom sources.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Sources list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _sources.length,
                    itemBuilder: (context, index) {
                      final source = _sources[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            source.isVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: source.isVisible
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                          title: Text(
                            source.isDefault
                                ? 'Default Source'
                                : 'Custom Source ${index}',
                            style: TextStyle(
                              fontWeight: source.isDefault
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            source.url,
                            style: TextStyle(
                              color: source.isVisible
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withOpacity(0.6),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Toggle visibility
                              IconButton(
                                icon: Icon(
                                  source.isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () => _toggleVisibility(index),
                                tooltip: source.isVisible ? 'Hide' : 'Show',
                              ),
                              // Edit (only for custom sources)
                              if (!source.isDefault)
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editSource(index),
                                  tooltip: 'Edit',
                                ),
                              // Remove (only for custom sources)
                              if (!source.isDefault)
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _removeSource(index),
                                  tooltip: 'Remove',
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Add custom source button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _addCustomSource,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Custom Source'),
                    ),
                  ),
                ),

                // Action buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withOpacity(0.3),
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Reset to default
                      TextButton.icon(
                        onPressed: _resetToDefault,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset to Default'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const Spacer(),
                      // Cancel
                      TextButton(
                        onPressed: _cancel,
                        child: Text(loc.cancel),
                      ),
                      const SizedBox(width: 8),
                      // Save
                      FilledButton.icon(
                        onPressed: _hasChanges ? _saveChanges : null,
                        icon: const Icon(Icons.save),
                        label: Text(loc.save),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );

    return content;
  }
}

class _AddSourceDialog extends StatefulWidget {
  final Function(String) onAdd;

  const _AddSourceDialog({required this.onAdd});

  @override
  State<_AddSourceDialog> createState() => _AddSourceDialogState();
}

class _AddSourceDialogState extends State<_AddSourceDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: const Text('Add Custom Source'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'URL',
            hintText: 'https://example.com/list.json',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a URL';
            }
            final uri = Uri.tryParse(value.trim());
            if (uri == null || !uri.hasAbsolutePath) {
              return 'Please enter a valid URL';
            }
            return null;
          },
          autofocus: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              widget.onAdd(_controller.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _EditSourceDialog extends StatefulWidget {
  final String initialUrl;
  final Function(String) onSave;

  const _EditSourceDialog({
    required this.initialUrl,
    required this.onSave,
  });

  @override
  State<_EditSourceDialog> createState() => _EditSourceDialogState();
}

class _EditSourceDialogState extends State<_EditSourceDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: const Text('Edit Source'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'URL',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a URL';
            }
            final uri = Uri.tryParse(value.trim());
            if (uri == null || !uri.hasAbsolutePath) {
              return 'Please enter a valid URL';
            }
            return null;
          },
          autofocus: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              widget.onSave(_controller.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: Text(loc.save),
        ),
      ],
    );
  }
}
